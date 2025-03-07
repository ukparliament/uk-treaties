# == Schema Information
#
# Table name: locations
#
#  id             :integer          not null, primary key
#  downcased_name :string(255)      not null
#  name           :string(255)      not null
#
class Location < ApplicationRecord
  
  has_many :signing_locations
  has_many :treaties,
    -> { order( 'signed_on, in_force_on' ) },
    :through => :signing_locations
end
