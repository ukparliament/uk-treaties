class AgreementController < ApplicationController
  
  def index
    @agreements = Agreement.all.order( 'signed_event_on' )
  end
  
  def show
    agreement = params[:agreement]
    @agreement = Agreement.find( agreement )
  end
end
