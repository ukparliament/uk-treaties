class AgreementType < ApplicationRecord
  
  has_many :agreements
    -> { order( 'signed_event_on' ) }
end
