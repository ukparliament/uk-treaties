class Treaty < ApplicationRecord
  
  belongs_to :subject, optional: true
  belongs_to :treaty_type, optional: true
end
