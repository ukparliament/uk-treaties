class ActionTypeController < ApplicationController
  
  def index
    @action_types = ActionType.all.order( 'label' )
    @page_title = 'Action types'
  end
  
  def show
    action_type = params[:action_type]
    @action_type = ActionType.find( action_type )
    @page_title = "Action types - #{@action_type.label}"
  end
end
