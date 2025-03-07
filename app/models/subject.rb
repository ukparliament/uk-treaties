# == Schema Information
#
# Table name: subjects
#
#  id      :integer          not null, primary key
#  subject :string(255)      not null
#
class Subject < ApplicationRecord
  
  has_many :treaties,
    -> { order( 'signed_on, in_force_on' ) }
end
