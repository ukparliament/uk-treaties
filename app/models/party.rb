# == Schema Information
#
# Table name: parties
#
#  id             :integer          not null, primary key
#  downcased_name :string(255)      not null
#  name           :string(255)      not null
#
class Party < ApplicationRecord

  has_many :actions,
    -> { order( 'action_on, effective_on' ) }
  has_many :treaty_parties
  has_many :treaties,
    -> { order( 'signed_on, in_force_on' ) },
  :through => :treaty_parties
end
