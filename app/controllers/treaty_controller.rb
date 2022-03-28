class TreatyController < ApplicationController
  
  def index
    @treaties = Treaty.all.order( 'signed_on, in_force_on' )
  end
  
  def show
    treaty = params[:treaty]
    @treaty = Treaty.find( treaty )
  end
end
