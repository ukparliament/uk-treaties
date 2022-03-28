class TreatyTypeController < ApplicationController
  
  def index
    @treaty_types = TreatyType.all
    @page_title = 'Treaty types'
  end
  
  def show
    treaty_type = params[:treaty_type]
    @treaty_type = TreatyType.find( treaty_type )
    @page_title = "#{@treaty_type.label} treaties"
  end
end
