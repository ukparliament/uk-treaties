class Party < ApplicationRecord

  has_many :actions,
    -> { order( 'action_on' ) }
end
