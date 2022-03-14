class TreatyType < ApplicationRecord
  
  has_many :treaties
    -> { order( 'signed_event_on' ) }
end
