class TreatyParty < ApplicationRecord
  
  belongs_to :treaty
  belongs_to :party
end
