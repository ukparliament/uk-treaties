require 'open-uri'
require 'nokogiri'

task :get_actions => :environment do
  puts "getting party actions from the HTML document"
  
  # We get all the treaties.
  treaties = Treaty.all
  
  # We loop through all the treaties.
  treaties.each do |treaty|
    if treaty.actions.empty?
      
      # We construct a URL to the file.
      doc_url = "https://treaties.fcdo.gov.uk/awweb/awarchive?type=file&item=#{treaty.record_id}"
      
      # We get XML from the file.
      xml = Nokogiri::HTML (URI.open( doc_url ) )
      
      # We loop through all table rows in the XML with a descendent table data column ...
      xml.xpath( '//tr[td]' ).each do |row|
        
        # ... and pull out the party string, action type string, action on date and effective on date.
        party_string = row.xpath( 'td[1]/text()' ).to_s
        action_type_string = row.xpath( 'td[2]/text()' ).to_s
        action_on = row.xpath( 'td[3]/text()' ).to_s
        effective_on = row.xpath( 'td[4]/text()' ).to_s
        
        # We attempt to find a party with the same name downcased.
        party = Party.find_by_downcased_name( party_string.downcase )
        
        # If there's not a party with the same name downcased ...
        unless party
          
          # ... we create the party.
          party = Party.new
          party.name = party_string
          party.downcased_name = party_string.downcase
          party.save
        end
        
        # We attempt to find an action type with the same label.
        action_type = ActionType.find_by_label( action_type_string )
        
        # If there's not an action type with the same label ...
        unless action_type
          
          # ... we create the action type.
          action_type = ActionType.new
          action_type.label = action_type_string
          action_type.save
        end
        
        # We create a new action.
        action = Action.new
        action.action_on = action_on
        action.effective_on = effective_on
        action.treaty = treaty
        action.party = party
        action.action_type = action_type
        action.save
      end
    end
  end
end





