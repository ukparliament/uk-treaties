class LocationController < ApplicationController
  
  def index
    @locations = Location.all.order( 'name' )
  end
  
  def show
    location = params[:location]
    @location = Location.find( location )
  end
end
