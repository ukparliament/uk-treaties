require 'rubygems'
require 'nokogiri'
require 'open-uri'


task :import => :environment do
  puts "importing"
  
  # We cycle through known treaty numbers on the FCDO website.
  (58135..82263).each do |number|
    
    # We check to see if this is an agreement we've already encountered.
    agreement = Agreement.find_by_fcdo_id( number )
    
    # If this is an agreement we've already encountered ...
    if agreement
      
      # ... we report that we've already imported this agreement.
      puts "Skipping agreement #{number}"
      
    # Otherwise, if this is an agreement we've not already encountered ...
    else
    
      # ... we report the treaty we're importing.
      puts "Importing treaty #{number}"
    
      # We fetch the 'metadata' for each treaty.
      doc = Nokogiri::HTML( URI.open("https://treaties.fcdo.gov.uk/awweb/awarchive?type=metadata&item=#{number}") )
    
      # We get the title of the treaty, ...
      title_string = doc.xpath( "//tr[td/text() = 'Title:']/td[2]/text()" ).to_s.strip
    
      # ... its description ...
      description_string = doc.xpath( "//tr[td/text() = 'Description:']/td[2]/text()" ).to_s.strip
    
      # ... and its subject.
      subject_string = doc.xpath( "//tr[td/text() = 'Subject:']/td[2]/text()" ).to_s.strip
      
      # If we've found a subject string ...
      unless subject_string.blank?
    
        # ... we check to see if this is a subject we've already encountered.
        subject = Subject.find_by_subject( subject_string )
    
        # If it's not a subject we've already encountered ...
        unless subject
      
          # We create a new subject.
          subject = Subject.new
          subject.subject = subject_string
          subject.save
        end
      end
    
      # We create a new treaty with a title and subject relationship.
      agreement = Agreement.new
      agreement.fcdo_id = number
      agreement.title = title_string
      agreement.description = description_string unless description_string.blank?
      agreement.subject = subject
      agreement.save
    
      #puts doc.xpath( "//tr[td/text() = 'Relation:']/td[2]/text()" ).to_s.split( '||' ).first
      doc.xpath( "//tr[td/text() = 'Relation:']" ).each do |relation|
        
        relation_text = relation.xpath( "td[2]/text()" ).to_s.split( '||' ).first
        relation = Relation.new
        relation.relation = relation_text
        relation.agreement = agreement
        relation.save
      end
    
      # We fetch the 'file' for each treaty.
      doc = Nokogiri::HTML( URI.open("https://treaties.fcdo.gov.uk/awweb/awarchive?type=file&item=#{number}") )
    
      # For each table row having a td ...
      doc.xpath( '//tr[td]' ).each do |country_action|
      
        # ... we pull out the party, action type, action date and effective date.
        party_string = country_action.xpath( "td[1]/text()" ).to_s.strip
        action_type_string = country_action.xpath( "td[2]/text()" ).to_s.strip
        action_date_string = country_action.xpath( "td[3]/text()" ).to_s.strip
        effective_date_string = country_action.xpath( "td[4]/text()" ).to_s.strip
      
        # We check to see if this is a party we've already encountered.
        # We use the downcased name to check and avoid creating the same party twice.
        party = Party.find_by_downcased_name( party_string.downcase )
      
        # If it's not a party we've already encountered ...
        unless party
      
          # ... we create a new party.
          party = Party.new
          party.name = party_string
          party.downcased_name = party_string.downcase
          party.save
        end
        
        # If we've found an action type string ...
        unless action_type_string.blank?
      
          # ... we check to see if this is an action type we've already encountered.
          action_type = ActionType.find_by_label( action_type_string )
      
          # If it's not an action type we've already encountered ...
          unless action_type
      
            # ... we create a new action type.
            action_type = ActionType.new
            action_type.label = action_type_string
            action_type.save
          end
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
end