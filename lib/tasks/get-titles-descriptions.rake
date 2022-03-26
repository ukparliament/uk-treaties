require 'open-uri'
require 'nokogiri'

task :get_titles_descriptions => :environment do
  puts "getting titles and descriptions from the HTML document"
  
  # We get all the treaties.
  treaties = Treaty.all
  
  # We loop through all the treaties.
  treaties.each do |treaty|
    
    # We construct a URL to the file.
    doc_url = "https://treaties.fcdo.gov.uk/awweb/awarchive?type=metadata&item=#{treaty.record_id}"
      
    # We get XML from the file.
    xml = Nokogiri::HTML (URI.open( doc_url ) )
    
    # We get the title from the XML.
    title = xml.xpath( "//tr[td/text() = 'Title:']/td[2]/text()" ).to_s
    
    # We get the description from the XML.
    description = xml.xpath( "//tr[td/text() = 'Description:']/td[2]/text()" ).to_s
    
    # If the description in the metadata file isn't blank ...
    unless description.blank?
      
      # ... if the title in the metadata file matches the title in the JSON ...
      if title.strip == treaty.title
        
        # ... and if the description in the metadata file does not match the title in the JSON ...
        if description.strip! != treaty.title
          
          # ... we set the title of the treaty to the description in the metadata file ...
          treaty.title = description.strip
          
          # ... the description of the treaty to the title in the metadata file ...
          treaty.description = title.strip
          
          # ... and save the treaty.
          treaty.save
        end
      end
    end
  end
end





