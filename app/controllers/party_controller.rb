class PartyController < ApplicationController
  
  def index
    @parties = Party.all.order( 'name' )
  end
  
  def show
    party = params[:party]
    @party = Party.find( party )
  end
end
