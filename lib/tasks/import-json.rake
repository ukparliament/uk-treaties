task :import_json => :environment do
  puts "importing JSON"
  
  Dir.entries( 'db/json' ).each do |file|
    if file.include?( '_batch.json' )
      doc = File.read( "db/json/#{file}" )
      json = JSON.parse( doc )
      json['csw:GetRecordsResponse']['csw:SearchResults']['iStoreRecord'].each do |record|
        puts '======='
        signed_event_location = record['signed_event_location']
        references = record['references']
        signed_event_date = record['signed_event_date']
        subject = record['subject']
        definative_eif_event_date = record['definative_eif_event_date']
        title = record['title']
        description = record['description']
        uuid = record['uuid']
        lb_document_id = record['lb_document_id']
        document_path = record['document_path']
        country_name = record['country_name']
        id = record['id']
        field3 = record['field3']
        document_url = record['document_url']
        
        agreement = Agreement.new
        agreement.signed_event_location = signed_event_location
        agreement.references = references
        agreement.signed_event_on = signed_event_date
        agreement.subject = subject
        agreement.definative_eif_event_date = definative_eif_event_date
        agreement.title = title
        agreement.description = description
        agreement.uuid = uuid
        agreement.lb_document_id = lb_document_id
        agreement.document_path = document_path
        agreement.country_name = country_name
        agreement.record_id = id
        agreement.field3 = field3
        agreement.document_url = document_url
        
        
      end
    end
  end
end





