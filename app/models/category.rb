class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  #attr_accessible :category_name , :member_id , :category_image, :sequence , :image_url, :background_color, :symbol1s_attributes, :hebrew, :default_skb
  field :category_name, type: String
  field :member_id, type: Integer
  field :category_image, type: String
  field :sequence, type: Integer
  field :image_url, type: String
  field :background_color, type: String
  field :symbol1s_attributes, type: String
  field :hebrew, type: String
  field :default_skb, type: boolean
  #has_paper_trail

  scope :updated_categories, lambda { |updated_date| where("updated_at >= :start_date AND updated_at <= :end_date",
                                                           {:start_date => updated_date, :end_date => Time.now}) }

  embeds_one :member
  embeds_many :symbol1s, :dependent => :destroy
  has_attached_file :category_image,:styles => { :medium => ["60x60#", :png] },
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => ":attachment/:file_name/:filename",
                    :preserve_files => true,
                    :bucket => 'olamundo-dev'
  validates_attachment_content_type :category_image, :content_type=>['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/bmp']
  accepts_nested_attributes_for :symbol1s, :allow_destroy => true
  # Need to validate this,Problem navigating to diff page instead of pop up.
  #validates_presence_of :sequence  ,:category_name,:category_image
  #validates_numericality_of :sequence

  def increment_category_sequence
     self.sequence = Category.count + 1
  end

  def symbol1s_with_sequence
    self.symbol1s.sort_by{|s| s.sequence}
  end

end
