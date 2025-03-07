# == Schema Information
#
# Table name: treaty_parties
#
#  id        :integer          not null, primary key
#  party_id  :integer          not null
#  treaty_id :integer          not null
#
# Foreign Keys
#
#  fk_party   (party_id => parties.id)
#  fk_treaty  (treaty_id => treaties.id)
#
class TreatyParty < ApplicationRecord
  
  belongs_to :treaty
  belongs_to :party
end
