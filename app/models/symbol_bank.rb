class SymbolBank < ActiveRecord::Base
  #attr_accessible :symbol_name, :image_name, :image_url, :symbol_image

  has_attached_file :symbol_image ,:styles => { :medium => ["108x108#", :png] },
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    #:path => ":attachment/:id/:style.:extension",
                    :path => ":attachment/:file_name/:filename",
                    :preserve_files => true,
                    :bucket => 'olamundo-dev'
  validates_attachment_content_type :symbol_image, :content_type=>['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/bmp']


  def self.update_symbol_bank(symbol_details)
    puts "symbol_details::::::::::::#{symbol_details.inspect}"
    if symbol_details
      bank = self.new
      bank.symbol_name = symbol_details.word
      bank.image_url = symbol_details.image_url
      puts "symbol_details.symbol_image:::::::::::::#{symbol_details.symbol_image.inspect}"
      bank.symbol_image_file_name = symbol_details.symbol_image_file_name
      bank.symbol_image_file_size = symbol_details.symbol_image_file_size
      bank.symbol_image_content_type = symbol_details.symbol_image_content_type
      bank.symbol_image_updated_at = Time.now
      bank.save
    end
  end

end
