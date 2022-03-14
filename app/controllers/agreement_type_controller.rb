class AgreementTypeController < ApplicationController
  
  def index
    @agreement_types = AgreementType.all
  end
  
  def show
    agreement_type = params[:agreement_type]
    @agreement_type = AgreementType.find( agreement_type )
  end
end
