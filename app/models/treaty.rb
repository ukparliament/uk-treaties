class Treaty < ApplicationRecord
  
  belongs_to :subject, optional: true
  belongs_to :treaty_type, optional: true
  
  has_many :treaty_parties
  has_many :parties,
    -> { order( 'name' ) },
    :through => :treaty_parties
  has_many :citations
end
