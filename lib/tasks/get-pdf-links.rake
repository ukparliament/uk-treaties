task :get_pdf_links => :environment do
  puts "getting PDF links from citations"
  
  # We get all the citations where the citation text contains text like '||https://'.
  citations = Citation.where( "citation like '%||https://%'" )
  
  # We loop through all the citatations we've found ...
  citations.each do |citation|
    
    # ... pull out the bit beyond the '||' ...
    pdf_link = citation.citation.split( '||' ).last
    
    # ... strip any whitespace from the start and end ...
    pdf_link.strip!
    
    # ... and add the link to the treaty the citation is attached to.
    citation.treaty.pdf_link = pdf_link
  end
end