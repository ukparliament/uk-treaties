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
        agreement_id = record['document_url'].strip.split( '\\' ).last.split( '.' ).first.to_i
        title = record['title']
        description = record['description']
        signed_event_location = record['signed_event_location']
        signed_event_date = record['signed_event_date']
        definative_eif_event_date = record['definative_eif_event_date']
        references = record['references']
        country_name = record['country_name']
        subject_string = record['subject']
        agreement_type_string = record['field3']
        record_id = record['id'].to_i
        lb_document_id = record['lb_document_id'].to_i
        if record_id != lb_document_id
          puts "shit"
          puts record_id
          puts lb_document_id
        end
        
        # We ignore ...
        # ... lb_document_id because this is always the same as the record_id.
        # ... document_path because it doesn't return any information not in document_url.
        
        # We know that, for each agreement with a given uuid, the data may contain multiple records.
        # For a 'duplicate' record, having the same uuid, only the record_id and the lb_document_id have been seen to differ.
        # We check to see if we've already seen an agreement with the same uuid as the record.
        agreement = Agreement.find_by_uuid( uuid )
        
        # If we've not seen an agreement with the same uuid as the record ...
        unless agreement
          
          # ... we create a new agreement.
          agreement = Agreement.new
          agreement.uuid = uuid.strip
          agreement.agreement_id = agreement_id
          agreement.title = title.strip if title
          agreement.description = description.strip if description
          agreement.signed_event_at = signed_event_location.strip if signed_event_location
          agreement.signed_event_on = signed_event_date.strip if signed_event_date
          agreement.reference_values = references.strip if references
          agreement.definative_eif_event_date = definative_eif_event_date.strip if definative_eif_event_date
          agreement.country_name = country_name.strip if country_name
          
          # If the agreement has an agreement type string ...
          unless agreement_type_string.blank?
            
            # ... we find the agreement type with this text ...
            agreement_type = AgreementType.find_by_short_name( agreement_type_string )
            
            # ... and attach the agreement to this agreement type.
            agreement.agreement_type = agreement_type
          end
          
          # If the agreement has a subject string ...
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
            
            # We attach the agreement to this subject.
            agreement.subject = subject
          end
          
          # We save the agreement.
          agreement.save
            
            
            
          
        # Otherwise, if we have seen an agreement with the same uuid as the record ...
        else
        
          # ... we do not create a new agreement.
          
          # This bit does the checking to see that everything that isn't a record_id or a lb_document_id doesn't differ from previous agreements with the same uuid ...
          # ... and will be stripped out at some point.
        if agreement.agreement_id != agreement_id
             puts agreement_id.inspect
             puts agreement.agreement_id.inspect
             puts "agreement id"
          end
          if agreement.title != title
             puts agreement_id
             puts "title"
          end
          if agreement.description != description
             puts agreement_id
             puts "desc"
          end
          if agreement.signed_event_at != signed_event_location
             puts agreement_id
             puts "signed event at"
          end
          if agreement.signed_event_on != signed_event_date
             puts agreement_id
             puts "signed event on"
          end
          if agreement.reference_values != references
            puts agreement_id
            puts "references"
          end
          if agreement.definative_eif_event_date != definative_eif_event_date
             puts agreement_id
             puts "definative eif event date"
          end
          if agreement.country_name != country_name
             puts agreement_id
             puts "country name"
          end
          if agreement.subject && agreement.subject.subject != subject_string
            puts agreement_id 
            puts "subject"
          end
          if agreement.agreement_type && agreement.agreement_type.short_name != agreement_type_string
            puts agreement_id
            puts "agreement type string"
          end
          if agreement.records.first.record_id != record_id
            puts "======="
            puts agreement_id
            puts record_id.inspect
            puts agreement.records.first.record_id.inspect
            puts "record id"
          end
          if agreement.records.first.lb_document_id != lb_document_id
            #puts agreement_id 
            #puts "lb document id"
          end
          
          
          
          
        end
        
        # Regardless of whether or not we've seen an agreement with the same uuid as the record ...
        # ... we create a new record ...
        record = Record.new
        record.record_id = record_id
        record.lb_document_id = lb_document_id
        # ... and attach it to the agreement.
        record.agreement = agreement
        record.save
      end
    end
  end
end