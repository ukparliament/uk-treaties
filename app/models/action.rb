class Action < ApplicationRecord
  
  belongs_to :agreement
  belongs_to :action_type, optional: true
  belongs_to :party
end
