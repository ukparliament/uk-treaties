class Location < ApplicationRecord
  
  has_many :signing_locations
  has_many :treaties,
    -> { order( 'signed_on, in_force_on' ) },
    :through => :signing_locations
end
