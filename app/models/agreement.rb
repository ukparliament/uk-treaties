class Agreement < ApplicationRecord
  
  belongs_to :subject, optional: true
  has_many :actions,
    -> { order( 'action_on' ) }
end
