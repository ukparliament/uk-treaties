class Agreement < ApplicationRecord
  
  belongs_to :subject, optional: true
  has_many :actions,
    -> { order( 'action_on' ) }
  has_many :relations
end
