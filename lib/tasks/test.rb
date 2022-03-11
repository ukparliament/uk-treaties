require 'json'

  Dir.entries( '/Users/robertbrook/Documents/uk-agreements/db/json' ).each do |file|
    if file.include?( 'batch' )
      doc = File.read( "/Users/robertbrook/Documents/uk-agreements/db/json/#{file}" )

      json = JSON.parse(doc)
#       p json
      puts json['csw:GetRecordsResponse']['csw:SearchResults']['iStoreRecord'].size
    end
  end
