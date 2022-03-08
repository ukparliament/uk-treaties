class AgreementController < ApplicationController
  
  def index
    @agreements = Agreement.all
  end
  
  def show
    agreement = params[:agreement]
    @agreement = Agreement.find( agreement )
  end
end
