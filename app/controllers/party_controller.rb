class PartyController < ApplicationController
  
  def index
    @parties = Party.all.order( 'name' )
  end
  
  def show
    party = params[:party]
    @party = Party.find( party )
  end
  
  def action_list
    party = params[:party]
    @party = Party.find( party )
  end
  
  def treaty_list
    party = params[:party]
    @party = Party.find( party )
  end
end
