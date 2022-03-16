class ActionTypeController < ApplicationController
  
  def index
    @action_types = ActionType.all.order( 'label' )
  end
  
  def show
    action_type = params[:action_type]
    @action_type = ActionType.find( action_type )
  end
end
