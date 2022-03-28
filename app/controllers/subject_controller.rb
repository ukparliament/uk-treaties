class SubjectController < ApplicationController
  
  def index
    @subjects = Subject.all.order( 'subject' )
    @page_title = 'Subjects'
  end
  
  def show
    subject = params[:subject]
    @subject = Subject.find( subject )
    @page_title = "Treaties on the subject of #{@subject.subject}"
  end
end
