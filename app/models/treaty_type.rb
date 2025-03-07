# == Schema Information
#
# Table name: treaty_types
#
#  id         :integer          not null, primary key
#  label      :string(12)       not null
#  short_name :string(5)        not null
#
class TreatyType < ApplicationRecord
  
  has_many :treaties,
    -> { order( 'signed_on, in_force_on' ) }
end
