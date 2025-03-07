# == Schema Information
#
# Table name: citations
#
#  id        :integer          not null, primary key
#  citation  :string(255)      not null
#  treaty_id :integer          not null
#
# Foreign Keys
#
#  fk_treaty  (treaty_id => treaties.id)
#
class Citation < ApplicationRecord
  
  belongs_to :treaty
end
