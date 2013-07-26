class Message
  include Mongoid::Document
  include Mongoid::Timestamps
   #attr_accessible :message_from, :message, :message_time, :message_to ,:user_contact_id, :read, :message_type
  field :message_from, type: String
  field :message, type: String
  field :message_time, type: Integer
  field :message_to, type: String
  field :user_contact_id, type: Integer
  field :read, type: String
  field :message_type, type: String

  embedded_in :contact ,:class_name => 'Member'
end
