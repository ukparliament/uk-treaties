class SigningLocation < ApplicationRecord
  
  belongs_to :treaty
  belongs_to :location
end
