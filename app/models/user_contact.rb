class UserContact < ActiveRecord::Base
  attr_accessible :contact_id ,:member_id ,:communicator_id
  belongs_to :member
  belongs_to :contact ,:class_name => 'Member'
  has_many :messages

  scope :by_contact, lambda{ |username , contact_name| where("member_id = ? AND contact_id = ?", username, contact_name)  }

end
