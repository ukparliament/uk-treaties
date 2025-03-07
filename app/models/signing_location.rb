# == Schema Information
#
# Table name: signing_locations
#
#  id          :integer          not null, primary key
#  location_id :integer          not null
#  treaty_id   :integer          not null
#
# Foreign Keys
#
#  fk_location  (location_id => locations.id)
#  fk_treaty    (treaty_id => treaties.id)
#
class SigningLocation < ApplicationRecord
  
  belongs_to :treaty
  belongs_to :location
end
