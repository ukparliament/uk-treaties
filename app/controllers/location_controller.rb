class LocationController < ApplicationController
  
  def index
    @locations = Location.all.order( 'name' )
    @page_title = 'Signing locations'
  end
  
  def show
    location = params[:location]
    @location = Location.find( location )
    @page_title = "Treaties signed in #{@location.name}"
  end
end
