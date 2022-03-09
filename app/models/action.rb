class Action < ApplicationRecord
  
  belongs_to :agreement
  belongs_to :action_type
  belongs_to :party
end
