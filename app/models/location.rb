class Location < ApplicationRecord
  
  has_many :signing_locations
  has_many :treaties,
    -> { order( 'in_force_on, signed_on' ) },
    :through => :signing_locations
end
