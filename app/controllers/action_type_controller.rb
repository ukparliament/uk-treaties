class ActionTypeController < ApplicationController
  
  def index
    @action_types = ActionType.all.order( 'label' )
  end
end
