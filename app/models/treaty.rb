class Treaty < ApplicationRecord
  
  belongs_to :subject, optional: true
  belongs_to :treaty_type, optional: true
  
  has_many :treaty_parties
  has_many :parties,
    -> { order( 'name' ) },
    :through => :treaty_parties
  has_many :citations
  has_many :actions
  has_many :signing_locations
  has_many :locations,
    -> { order( 'name' ) },
    :through => :signing_locations
end
