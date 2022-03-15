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
        
        # document_urls take the form https://treaties.fcdo.gov.uk/data/Library2\html\{id}.html ...
        # ... where the only bit we're interested in is {id}. 
        # We get the document url, split once to get the portion beyond the last - escaped - backslash, again to get the portion before the dot and convert to an integer.
        treaty_id = record['document_url'].strip.split( '\\' ).last.split( '.' ).first.to_i
        record_id = record['id'].to_i
        title = record['title']
        description = record['description']
        signed_on = record['signed_event_date']
        in_force_on = record['definative_eif_event_date']
        
        
        
        signed_in = record['signed_event_location']
        references = record['references']
        
        
        
        treaty_type_string = record['field3']
        subject_string = record['subject']
        parties_string = record['country_name']
        
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
          treaty.treaty_id = treaty_id
          treaty.record_id = record_id
          treaty.title = title.strip if title
          treaty.description = description.strip if description
          treaty.signed_on = signed_on
          treaty.in_force_on = in_force_on
          
          
          
          treaty.signed_in = signed_in.strip if signed_in
          treaty.reference_values = references.strip if references
          
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