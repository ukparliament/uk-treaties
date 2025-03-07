# == Schema Information
#
# Table name: action_types
#
#  id    :integer          not null, primary key
#  label :string(255)      not null
#
class ActionType < ApplicationRecord
  
  has_many :actions,
    -> { order( 'action_on, effective_on' ) }
end
