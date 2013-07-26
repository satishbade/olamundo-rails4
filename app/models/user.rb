class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable , :validatable #,:confirmable

  field :email, type: String
  field :password, type: String
  field :password_confirmation, type: String
  field :remember_me, type: String
  field :members_attributes, type: String
  field :verification_code, type: String
  field :status, type: String
  field :title, type: String
  field :body, type: String

  #validates :password, :length => { :minimum =>6 } ,:message => "Password is too short"
  validates_confirmation_of :password #,:message=>"Password doesn't match"

  validates_presence_of :password, :email, :message=>"Can't be blank"
  validates_uniqueness_of :email,  :message=>"Email exists!"
  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me,:members_attributes, :verification_code, :status
  # attr_accessible :title, :body
  #---------------need to change the below line------------------------#
  embeds_many :members    #, :dependent => :destroy
  #---------------------------------------#
  embeds_many :user_contacts
  #---------------need to change the below line------------------------#
  #embeds_many :contacts ,:inverse_of => :user_contacts
  #---------------------------------------#
  embeds_many :messages

  #accepts_nested_attributes_for :members, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :members, :allow_destroy => true
  validates_associated :members

end



