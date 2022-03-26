task :super => [
  :import_json,
  :get_actions,
  :get_pdf_links,
  :get_titles_descriptions
]