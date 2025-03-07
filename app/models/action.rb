# == Schema Information
#
# Table name: actions
#
#  id             :integer          not null, primary key
#  action_on      :date
#  effective_on   :date
#  action_type_id :integer
#  party_id       :integer          not null
#  treaty_id      :integer          not null
#
# Foreign Keys
#
#  fk_action_type  (action_type_id => action_types.id)
#  fk_party        (party_id => parties.id)
#  fk_treaty       (treaty_id => treaties.id)
#
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
