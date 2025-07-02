class MetaController < ApplicationController
  
  def index
    @page_title = 'About this website'
  end
  
  def cookies
    @page_title = 'Cookies'
  end
end
