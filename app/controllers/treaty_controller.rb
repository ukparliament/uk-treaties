class TreatyController < ApplicationController
  
  def index
    @treaties = Treaty.all.order( 'signed_on, in_force_on' )
    @page_title = 'Treaties'
  end
  
  def show
    treaty = params[:treaty]
    @treaty = Treaty.find( treaty )
    @page_title = @treaty.title
  end
end
