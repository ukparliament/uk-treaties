class Party < ApplicationRecord

  has_many :actions,
    -> { order( 'action_on' ) }
  has_many :treaty_parties
  has_many :treaties,
    -> { order( 'in_force_on, signed_on' ) },
  :through => :treaty_parties
end
