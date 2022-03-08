class AgreementController < ApplicationController
  
  def index
    @agreements = Agreement.all
  end
end
