class ActionType < ApplicationRecord
  
  has_many :actions,
    -> { order( 'action_on, effective_on' ) }
end
