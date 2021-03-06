class Relatedsymbol
  include Mongoid::Document
  include Mongoid::Timestamps
  #attr_accessible :symbol1_id, :symbol_text, :symbol_image, :image_url, :sequence, :symbol_image_file_name, :hebrew
  #has_paper_trail

  field :symbol1_id, type: Integer
  field :symbol_text, type: String
  field :symbol_image, type: String
  field :image_url, type: String
  field :sequence, type: String
  field :symbol_image_file_name, type: String
  field :hebrew, type: String

  scope :updated_related_symbols, lambda { |updated_date| where("updated_at >= :start_date AND updated_at <= :end_date",
                                                           {:start_date => updated_date, :end_date => Time.now}) }

  embeds_many :symbol1
  has_attached_file :symbol_image ,:styles => { :medium => ["108x108#", :png] },
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => ":attachment/:file_name/:filename",
                    :preserve_files => true,
                    :bucket => 'olamundo-dev'
  validates_attachment_content_type :symbol_image, :content_type=>['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/bmp']

end
