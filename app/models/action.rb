class Action < ApplicationRecord
  
  belongs_to :treaty
  belongs_to :action_type, optional: true
  belongs_to :party
  
  def action_on_display
    action_on_display = ''
    if self.action_on
      action_on_display = self.action_on.strftime( '%-d %B %Y')
    end
    action_on_display
  end
  
  def effective_on_display
    effective_on_display = ''
    if self.effective_on
      effective_on_display = self.effective_on.strftime( '%-d %B %Y')
    end
    effective_on_display
  end
end
