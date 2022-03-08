require 'rubygems'
require 'nokogiri'
require 'open-uri'


task :import => :environment do
  puts "importing"
  (58135..82261).each do |number|
    puts "========="
    puts number
    doc = Nokogiri::HTML( URI.open("https://treaties.fcdo.gov.uk/awweb/awarchive?type=metadata&item=#{number}") )
    title_string = doc.xpath( "//tr[td/text() = 'Title:']/td[2]/text()" ).to_s
    subject_string = doc.xpath( "//tr[td/text() = 'Subject:']/td[2]/text()" ).to_s.strip
    subject = Subject.find_by_subject( subject_string )
    unless subject
      subject = Subject.new
      subject.subject = subject_string
      subject.save
    end
    agreement = Agreement.new
    agreement.title = title_string
    agreement.subject = subject
    agreement.save
    
    
    
    puts doc.xpath( "//tr[td/text() = 'Relation:']/td[2]/text()" ).to_s.split( '||' ).first
    doc = Nokogiri::HTML( URI.open("https://treaties.fcdo.gov.uk/awweb/awarchive?type=file&item=#{number}") )
    doc.xpath( '/tr[td]' ).each do |country_action|
      puts country_action.xpath( "td[1]/text()" )
      puts country_action.xpath( "td[1]/text()" )
    end
    
    
    
  end
end
