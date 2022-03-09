class Agreement < ApplicationRecord
  
  belongs_to :subject
  has_many :actions
end
