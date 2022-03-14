class Agreement < ApplicationRecord
  
  
  #has_many :actions,
    #-> { order( 'action_on' ) }
  #has_many :relations
  
  belongs_to :subject, optional: true
  belongs_to :agreement_type, optional: true
  has_many :records
end
