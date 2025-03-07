# == Schema Information
#
# Table name: treaties
#
#  id             :integer          not null, primary key
#  description    :string(10000)
#  in_force_on    :date
#  pdf_file_name  :string(255)
#  signed_on      :date
#  title          :string(10000)    not null
#  uuid           :string(36)       not null
#  record_id      :integer          not null
#  subject_id     :integer
#  treaty_id      :integer
#  treaty_type_id :integer
#
# Foreign Keys
#
#  fk_subject      (subject_id => subjects.id)
#  fk_treaty_type  (treaty_type_id => treaty_types.id)
#
class Treaty < ApplicationRecord
  
  belongs_to :subject, optional: true
  belongs_to :treaty_type, optional: true
  
  has_many :treaty_parties
  has_many :parties,
    -> { order( 'name' ) },
    :through => :treaty_parties
  has_many :citations
  has_many :actions
  has_many :signing_locations
  has_many :locations,
    -> { order( 'name' ) },
    :through => :signing_locations
    
  def pdf_link
    if self.pdf_file_name
      pdf_link = "https://treaties.fcdo.gov.uk/data/Library2/pdf/#{self.pdf_file_name}"
    end
    pdf_link
  end
  
  def signed_on_display
    signed_on_display = ''
    if self.signed_on
      signed_on_display = self.signed_on.strftime( '%-d %B %Y')
    end
    signed_on_display
  end
  
  def in_force_on_display
    in_force_on_display = ''
    if self.in_force_on
      in_force_on_display = self.in_force_on.strftime( '%-d %B %Y')
    end
    in_force_on_display
  end
end
