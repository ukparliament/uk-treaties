class SubjectController < ApplicationController
  
  def index
    @subjects = Subject.all.order( 'subject' )
  end
  
  def show
    subject = params[:subject]
    @subject = Subject.find( subject )
  end
end
