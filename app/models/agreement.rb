class Agreement < ApplicationRecord
  
  belongs_to :subject
  has_many :actions,
    -> { order( 'action_on' ) }
end
