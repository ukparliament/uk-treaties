class Subject < ApplicationRecord
  
  has_many :treaties,
    -> { order( 'signed_on, in_force_on' ) }
end
