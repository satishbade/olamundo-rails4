class UserContact
  #attr_accessible :contact_id ,:member_id ,:communicator_id
  include Mongoid::Document
  include Mongoid::Timestamps

  field :contact_id, type: Integer
  field :member_id, type: Integer
  field :communicator_id, type: Integer

  embedded_in :member
  embedded_in :contact ,:class_name => 'Member'
  embeds_many :messages

  scope :by_contact, lambda{ |username , contact_name| where("member_id = ? AND contact_id = ?", username, contact_name)  }

end
