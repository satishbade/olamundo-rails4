class IpadDevise
  include Mongoid::Document
  include Mongoid::Timestamps
  #attr_accessible :devise_token, :member_id, :status
  field :devise_token, type: text
  field :member_id, type: integer
  field :status, type: string
end
