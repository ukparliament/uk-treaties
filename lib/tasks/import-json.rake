task :import_json => :environment do
  puts "importing JSON"
  
  Dir.entries( 'db/json' ).each do |file|
    if file.include?( 'batch' )
      doc = File.read( "db/json/#{file}" )
      #doc = doc.gsub(/'/, '"')
      #doc = doc.gsub("'",/"/)
      
      
      
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
        
        puts "signing location: #{signed_event_location}"
        puts "references: #{references}"
        puts "signing date: #{signed_event_date}"
        puts "subject: #{subject}"
        puts "title: #{title}"
        puts "description: #{description}"
        puts "uuid: #{uuid}"
        puts "lb document id: #{lb_document_id}"
        puts "country name: #{document_path}"
        puts "document path: #{country_name}"
        puts "field3: #{field3}"
        puts "document url: #{document_url}"
      end
    end
  end
end





