task :import_json => :environment do
  puts "importing JSON"
  
  # We get all the files in the json folder.
  Dir.entries( 'db/json' ).each do |file|
    
    # We only want files with _batch.json in the title.
    # If the file name includes '_batch.json' ...
    if file.include?( '_batch.json' )
      
      # ... we read the file ...
      doc = File.read( "db/json/#{file}" )
      
      # ... and parse it as JSON.
      json = JSON.parse( doc )
      
      # For each record in the file ...
      json['csw:GetRecordsResponse']['csw:SearchResults']['iStoreRecord'].each do |record|
        
        # ... we extract the details we want to store.
        uuid = record['uuid']
        record_id = record['id'].to_i
        title = record['title']
        description = record['description']
        signed_on = record['signed_event_date']
        in_force_on = record['definative_eif_event_date']
        signed_at_string = record['signed_event_location']
        citation_string = record['references']
        treaty_type_string = record['field3']
        subject_string = record['subject']
        parties_string = record['country_name']
        
        # document_urls take the form https://treaties.fcdo.gov.uk/data/Library2\{format}\{id}.{format} ...
        # ... where format is either html, pdf or PDF.
        # Where the format is html, we can use the ID to link to the treaty metadata file and party action HTML.
        # Where the format is pdf, we can use the document_url to get the file name of the treaty PDF.
        # We get the document_url from the JSON.
        document_url = record['document_url']
        
        # If the document_url includes \html ...
        if document_url.include?( "\html" )
          
          # ... we construct the treaty_id by taking the document url, splitting once to get the portion beyond the last - escaped - backslash, again to get the portion before the dot and converting to an integer.
          treaty_id = document_url.strip.split( '\\' ).last.split( '.' ).first.to_i
          
        # If the document_url includes \pdf or \PDF ...
        elsif document_url.include?( "\pdf" ) or document_url.include?( "\PDF" )
          
          # ... we construct the pdf file name by splitting on the last - escaped - backslash.
          pdf_file_name = document_url.split( '\\' ).last
        end
        
        # We ignore ...
        # ... lb_document_id because this is always the same as the record_id.
        # ... document_path because it doesn't return any information not in document_url.
        
        # We know that, for each treaty with a given uuid, the data may contain multiple records.
        # We also know that no other details vary between records.
        # We check to see if we've already seen a treaty with the same uuid as the record.
        treaty = Treaty.find_by_uuid( uuid )
        
        # If we've not seen a treaty with the same uuid as the record ...
        unless treaty
          
          # ... we create a new treaty.
          treaty = Treaty.new
          treaty.uuid = uuid.strip
          treaty.treaty_id = treaty_id if treaty_id
          treaty.record_id = record_id
          treaty.title = title.strip if title
          treaty.description = description.strip if description
          treaty.signed_on = signed_on
          treaty.in_force_on = in_force_on
          treaty.pdf_file_name = pdf_file_name if pdf_file_name
          
          # If the treaty has a treaty type string ...
          unless treaty_type_string.blank?
            
            # ... we find the treaty type with this text ...
            treaty_type = TreatyType.find_by_short_name( treaty_type_string )
            
            # ... and attach the treaty to this treaty type.
            treaty.treaty_type = treaty_type
          end
          
          # If the treaty has a subject string ...
          unless subject_string.blank?
            
            # ... we find the subject with this text.
            subject = Subject.find_by_subject( subject_string )
            
            # If no such subject exists ...
            unless subject 
              
              # ... we create a new subject.
              subject = Subject.new
              subject.subject = subject_string
              subject.save
              
            end
            
            # We attach the treaty to this subject.
            treaty.subject = subject
          end
          
          # If the treaty has a parties string ...
          unless parties_string.blank?
            
            # We split the parties string on semicolons and loop through each fragment.
            parties_string.split( ';' ).each do |party_string|
              
              # We strip any whitespace from the start and end of the party string.
              party_string = party_string.strip
              
              # ... we find the party with with this downcased name.
              party = Party.find_by_downcased_name( party_string.downcase )
              
              # If no such party exists ...
              unless party
                
                # ... we create a new party.
                party = Party.new
                party.name = party_string
                party.downcased_name = party_string.downcase
                party.save
              end
              
              # We create a new treaty party to attach the party to the treaty.
              treaty_party = TreatyParty.new
              treaty_party.treaty = treaty
              treaty_party.party = party
              treaty_party.save
            end
          end
          
          # If the treaty has a citations string ...
          unless citation_string.blank?
            
            # We split the citation string on semicolons and loop through each fragment.
            citation_string.split( ';' ).each do |citation_string|
              
              # We strip any whitespace from the start and end of the citation string.
              citation_string = citation_string.strip
              
              # We create a new citation attached to the aggreement.
              citation = Citation.new
              citation.citation = citation_string
              citation.treaty = treaty
              citation.save
            end
          end
          
          # If the treaty has a signed at string ...
          unless signed_at_string.blank?
            
            # ... we set up locations and signing locations.
            set_signing_locations( treaty, signed_at_string )
          end
          
          # We save the treaty.
          treaty.save
          
        # Otherwise, if we have seen an treaty with the same uuid as the record ...
        else
        
          # ... we do not create a new treaty.
        end
      end
    end
  end
end

# ## A method to set locations and signing locations.
def set_signing_locations( treaty, signed_at_string )
  
  # We strip whitespace from the start and end of the signed at string.
  signed_at_string.strip!
  
  # The signing location data is horrendously messy. Treaties may be signed in one or more locations but only one field is provided meaning records take different approaches to managing multiple locations. Some split by slashes, some by 'and', some by ampersands, some by semicolons and some just don't bother. This method is an attempt to reconstruct a silk purse from some badly chewed pigs' ears.
  
  # If the signed at string is 'U/N' ...
  if signed_at_string == 'U/N'
    
    # ... we find or create a location with the name 'U/N'.
    find_or_create_location_with_signing( 'U/N', treaty )
    
  # Otherwise, if the signed at string is 'Amman-Jerusalem', 'Cairo-Jerusalem', 'London-Paris', 'London-Paris-Rome' or 'Stockholm-Chistiania' ...
  elsif signed_at_string == 'Amman-Jerusalem' or signed_at_string == 'Cairo-Jerusalem' or signed_at_string == 'London-Paris' or signed_at_string == 'London-Paris-Rome' or signed_at_string == 'Stockholm-Chistiania'
    
    # ... we split the signed at string on the hyphens ...
    signed_at_string.split( '-' ).each do |location_string|
      
      # ... and find or create the location and signing.
      find_or_create_location_with_signing( location_string, treaty )
    end
    
  # Otherwise, if the signed at string is 'The Hague,Berlin' ...
  elsif signed_at_string == 'The Hague,Berlin'
    
    # ... we split the signed at string on the comma ...
    signed_at_string.split( ',' ).each do |location_string|
      
      # ... and find or create the location and signing.
      find_or_create_location_with_signing( location_string, treaty )
    end
    
  # Otherwise, if the signed at string is 'Canberra Bern' ...
  elsif signed_at_string == 'Canberra Bern'
    
    # ... we split the signed at string on the space ...
    signed_at_string.split( ' ' ).each do |location_string|
      
      # ... and find or create the location and signing.
      find_or_create_location_with_signing( location_string, treaty )
    end
    
  # Otherwise, if the signed at string is 'London St Petersburg' ...
  elsif signed_at_string == 'London St Petersburg'
    
    # ... we find or create the location and signing for London ...
    find_or_create_location_with_signing( 'London', treaty )
    
    # ... and find or create the location and signing for St Petersburg.
    find_or_create_location_with_signing( 'St Petersburg', treaty )
    
  # Otherwise, if the signed at string is none of the above ...
  else
    
    # ... we know that location names may be split by ' and ', ampersand, semicolon or slash ...
    # ... so we check for inclusion.
    
    # If the signed at string includes ' and ' ...
    if signed_at_string.include?( ' and ' )
      
      # ... we split the signed at string on the word 'and' ...
      signed_at_string.split( ' and ' ).each do |location_string|
        
        # ... and find or create the location and signing.
        find_or_create_location_with_signing( location_string, treaty )
      end
      
      
    # Otherwise, if the signed at string includes an ampersand ...
    elsif signed_at_string.include?( '&' )
      
      # ... we split the signed at string on ampersands ...
      signed_at_string.split( '&' ).each do |location_string|
        
        # ... and find or create the location and signing.
        find_or_create_location_with_signing( location_string, treaty )
      end
      
    # Otherwise, if the signed at string includes a semicolon ...
    elsif signed_at_string.include?( ';' )
      
      # ... we split the signed at string on semicolons ...
      signed_at_string.split( ';' ).each do |location_string|
        
        # ... and find or create the location and signing.
        find_or_create_location_with_signing( location_string, treaty )
      end
      
    # Otherwise, if the signed at string includes a slash ...
    elsif signed_at_string.include?( '/' )
      
      # ... we split the signed at string on slashes ...
      signed_at_string.split( '/' ).each do |location_string|
        
        # ... and find or create the location and signing.
        find_or_create_location_with_signing( location_string, treaty )
      end

  
    # Otherwise, if the signed at string doesn't include 'and', an ampersand, a semicolon or a slash ...
    else
  
      # ... we find or create the location and signing.
      find_or_create_location_with_signing( signed_at_string, treaty )
    end
  end
end

## A method to find or create a location and signing.
def find_or_create_location_with_signing( location_name, treaty )
  
  # We strip the whitespace from the location name.
  location_name.strip!
  
  # We try to find a location with this name downcased.
  location = Location.find_by_downcased_name( location_name.downcase )
  
  # If no such location exists ...
  unless location
    
    # ... we create a new location.
    location = Location.new
    location.name = location_name
    location.downcased_name = location_name.downcase
    location.save
  end
  
  # We create a new signing location.
  signing_location = SigningLocation.new
  signing_location.treaty = treaty
  signing_location.location = location
  signing_location.save
end