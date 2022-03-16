class Action < ApplicationRecord
  
  belongs_to :treaty
  belongs_to :action_type, optional: true
  belongs_to :party
end
