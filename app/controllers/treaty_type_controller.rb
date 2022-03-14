class TreatyTypeController < ApplicationController
  
  def index
    @treaty_types = TreatyType.all
  end
  
  def show
    treaty_type = params[:treaty_type]
    @treaty_type = TreatyType.find( treaty_type )
  end
end
