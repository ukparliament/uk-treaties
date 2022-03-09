require 'rubygems'
require 'nokogiri'
require 'open-uri'


task :import => :environment do
  puts "importing"
  
  # We cycle through known treaty numbers on the FCDO website.
  (58135..82261).each do |number|
    
    # We report the treaty we're importing.
    puts "Importing treaty #{number}"
    
    # We fetch the 'metadata' for each treaty.
    doc = Nokogiri::HTML( URI.open("https://treaties.fcdo.gov.uk/awweb/awarchive?type=metadata&item=#{number}") )
    
    # We get the title of the treaty ...
    title_string = doc.xpath( "//tr[td/text() = 'Title:']/td[2]/text()" ).to_s
    
    # ... and its subject.
    subject_string = doc.xpath( "//tr[td/text() = 'Subject:']/td[2]/text()" ).to_s.strip
    
    # We check to see if this is a subject we've already encountered.
    subject = Subject.find_by_subject( subject_string )
    
    # If it's not a subject we've already encountered ...
    unless subject
      
      # We create a new subject.
      subject = Subject.new
      subject.subject = subject_string
      subject.save
    end
    
    # We create a new treaty with a title and subject relationship.
    agreement = Agreement.new
    agreement.title = title_string
    agreement.subject = subject
    agreement.save
    
    #puts doc.xpath( "//tr[td/text() = 'Relation:']/td[2]/text()" ).to_s.split( '||' ).first
    
    # We fetch the 'file' for each treaty.
    doc = Nokogiri::HTML( URI.open("https://treaties.fcdo.gov.uk/awweb/awarchive?type=file&item=#{number}") )
    
    # For each table row having a td ...
    doc.xpath( '//tr[td]' ).each do |country_action|
      #puts country_action
      
      # ... we pull out the party, action type, action date and effective date.
      party_string = country_action.xpath( "td[1]/text()" ).to_s
      puts party_string
      action_type_string = country_action.xpath( "td[2]/text()" ).to_s
      puts action_type_string
      action_date_string = country_action.xpath( "td[3]/text()" ).to_s
      puts action_date_string
      effective_date_string = country_action.xpath( "td[4]/text()" ).to_s
      puts effective_date_string
      
      # We check to see if this is a party we've already encountered.
      party = Party.find_by_name( party_string )
      
      # If it's not a party we've already encountered ...
      unless party
      
        # ... we create a new party.
        party = Party.new
        party.name = party_string
        party.save
      end
      
      # We check to see if this is an action type we've already encountered.
      action_type = ActionType.find_by_label( action_type_string )
      
      # If it's not an action type we've already encountered ...
      unless action_type
      
        # ... we create a new action type.
        action_type = ActionType.new
        action_type.label = action_type_string
        action_type.save
      end
      
      # We create a new action.
      action = Action.new
      action.action_on = action_date_string if action_date_string
      action.effective_on = effective_date_string
      action.agreement = agreement
      action.action_type = action_type
      action.party = party
      action.save
    end
  end
end