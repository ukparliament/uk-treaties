class PartyController < ApplicationController
  
  def index
    @parties = Party.all.order( 'name' )
    @page_title = 'Parties'
  end
  
  def show
    party = params[:party]
    @party = Party.find( party )
    @page_title = "Parties - #{@party.name}"
  end
  
  def action_list
    party = params[:party]
    @party = Party.find( party )
    @page_title = "Actions by #{@party.name}"
  end
  
  def treaty_list
    party = params[:party]
    @party = Party.find( party )
    @page_title = "Treaties with #{@party.name}"
  end
end
