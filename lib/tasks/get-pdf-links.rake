task :get_pdf_links => :environment do
  puts "getting PDF links from citations"
  
  # We get all the citations where the citation text contains text like '||https://'.
  citations = Citation.where( "citation like '%||https://%'" )
  
  # We loop through all the citatations we've found ...
  citations.each do |citation|
    
    # ... pull out the bit beyond the '||' ...
    pdf_file_name = citation.citation.split( '||' ).last
    
    # ... pull out the bit beyond the final '/' ...
    pdf_file_name = pdf_file_name.split( '/').last
    
    # ... strip any whitespace from the start and end ...
    pdf_file_name.strip!
    
    # ... if the treaty does not have a PDF file name with the same value as this PDF file name ...
    # ... which is, in practice, none of them do ...
    # ... nor indeed does any treaty having this form of citation have a PDF file name in the document URL ...
    if citation.treaty.pdf_file_name != pdf_file_name
      
      # ... we set the treaty PDF file name to this file name ... 
      citation.treaty.pdf_file_name = pdf_file_name
      
      # ... and save the treaty.
      citation.treaty.save
    end
  end
end