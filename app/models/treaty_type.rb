class TreatyType < ApplicationRecord
  
  has_many :treaties,
    -> { order( 'in_force_on, signed_on' ) }
end
