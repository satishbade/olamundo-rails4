class Relatedsymbol < ActiveRecord::Base
  #attr_accessible :symbol1_id, :symbol_text, :symbol_image, :image_url, :sequence, :symbol_image_file_name, :hebrew
  #has_paper_trail

  scope :updated_related_symbols, lambda { |updated_date| where("updated_at >= :start_date AND updated_at <= :end_date",
                                                           {:start_date => updated_date, :end_date => Time.now}) }

  belongs_to :symbol1
  has_attached_file :symbol_image ,:styles => { :medium => ["108x108#", :png] },
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => ":attachment/:file_name/:filename",
                    :preserve_files => true,
                    :bucket => 'olamundo-dev'
  validates_attachment_content_type :symbol_image, :content_type=>['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/bmp']

end
