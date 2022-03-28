class Party < ApplicationRecord

  has_many :actions,
    -> { order( 'action_on, effective_on' ) }
  has_many :treaty_parties
  has_many :treaties,
    -> { order( 'signed_on, in_force_on' ) },
  :through => :treaty_parties
end
