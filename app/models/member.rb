class Member
  include Mongoid::Document
  include Mongoid::Timestamps
  #attr_accessible :name, :relationship , :user_id, :avatar, :image_url, :first_name, :last_name
  field :name, type: String
  field :relationship, type: String
  field :user_id, type: Integer
  field :avatar, type: String
  field :image_url, type: String
  field :first_name, type: String
  field :last_name, type: String

  belongs_to :user
  has_many :categories
  has_many :user_contacts
  #has_many :contacts ,:through => :user_contacts
  has_many :messages
  #has_attached_file :avatar, :styles => { :medium => "60x60#" },
  #                  :storage => :s3,
  #                  :s3_credentials => "#{Rails.root}/config/s3.yml",
  #                  :path => ":attachment/:file_name/:filename",
  #                  :preserve_files => true,
  #                  :bucket => 'olamundo-dev'
  validates_presence_of :name , :relationship ,:message => "can't be blank"
  #validates_attachment_content_type :avatar, :content_type=>['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/bmp']
  #validates_attachment_presence :avatar   ,:message => "can not be blank, select a file"
end
