class Symbol1
  include Mongoid::Document
  include Mongoid::Timestamps
  #attr_accessible :category_id, :sequence, :word, :symbol_image , :image_url, :relatedsymbols_attributes, :symbol_type, :symbol_image_file_name, :hebrew

  field :category_id, type: Integer
  field :sequence, type: Integer
  field :word, type: String
  field :symbol_image, type: String
  field :image_url, type: String
  field :relatedsymbols_attributes, type: String
  field :symbol_type, type: String
  field :symbol_image_file_name, type: String
  field :hebrew, type: String


  scope :updated_symbols, lambda { |updated_date| where("updated_at >= :start_date AND updated_at <= :end_date",
                                                           {:start_date => updated_date, :end_date => Time.now}) }

  belongs_to :category
  has_many :relatedsymbols , :dependent => :destroy
  accepts_nested_attributes_for :relatedsymbols, :allow_destroy => true
  has_attached_file :symbol_image ,:styles => { :medium => ["108x108#", :png] },
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    #:path => ":attachment/:id/:style.:extension",
                    :path => ":attachment/:file_name/:filename",
                    :preserve_files => true,
                    :bucket => 'olamundo-dev'
  validates_attachment_content_type :symbol_image, :content_type=>['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/bmp']

  def related_symbols_with_sequence
    self.relatedsymbols.sort_by{|rs| rs.sequence}
  end


  def self.search(search)
    if search
      find(:all, :conditions => ['lower(word) = ?', "#{search.downcase}"])
    else
      #find(:all)
      return nil
    end
  end

  def self.search1(search)
    if search
      find(:all, :conditions => ['lower(word)  LIKE ?', "#{search.downcase}%"])
    else
      return nil
    end
  end

end
