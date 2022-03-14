class TreatyController < ApplicationController
  
  def index
    @treaties = Treaty.all.order( 'in_force_on, signed_on' )
  end
  
  def show
    treaty = params[:treaty]
    @treaty = Treaty.find( treaty )
  end
end
