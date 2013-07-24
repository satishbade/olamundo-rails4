require 'open-uri'


namespace :image_load do
  task :for_each_membernew => :environment do
    require 'open-uri'
    require 'roo'

    resource = Member.find(ENV["resource"])
      S3category.all.each do |s3_category|
          @category = resource.categories.build
          @category.category_name =   s3_category.category_name
          @category.sequence = s3_category.sequence
          @category.category_image = s3_category.category_image # or s3_category.category_image.url(:medium)
          puts "category_name: #{@category.category_name}"
          puts "category_image: #{@category.category_image}"
          @category.save
          #image_counter = 0
          s3_category.s3symbols.each do |s3_symbol|
          #if image_counter < 10
          #  image_counter += 1
          @symbol = @category.symbol1s.build
          @symbol.word = s3_symbol.word
          @symbol.sequence = s3_symbol.sequence
          if !s3_symbol.symbol_image.url.include?("missing.")
          image_file = open(s3_symbol.symbol_image.url)
          #{|f| f.read }

          #image_file = s3_symbol.symbol_image
          @symbol.symbol_image = image_file # s3_symbol.symbol_image.url(:medium)
          image_file.close
          @symbol.save
          end
          #else
          #  break
          #end
          end
      end

  end
end