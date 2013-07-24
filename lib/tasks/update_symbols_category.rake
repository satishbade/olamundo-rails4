namespace :update_image do
  task :from_dropbox => :environment do
    require 'open-uri'
    Dir.entries("/home/prabhanshu/Downloads/olamundo image 9th april/olamundo image 9th april/SymbolImages").each do |image_name|

      Symbol1.all.each do |s|
        if s.symbol_image_file_name == image_name
          image_file = File.open("/home/prabhanshu/Downloads/olamundo image 9th april/olamundo image 9th april/SymbolImages/#{image_name}")
          s.update_attributes(:symbol_image => image_file)
          image_file.close
          image_url = s.symbol_image.url(:medium)
          s.update_attributes(:image_url => image_url)
        end
      end
      Relatedsymbol.all.each do |rs|
        if rs.symbol_image_file_name == image_name
          image_file = File.open("/home/prabhanshu/Downloads/olamundo image 9th april/olamundo image 9th april/SymbolImages/#{image_name}")
          rs.update_attributes(:symbol_image => image_file)
          image_file.close
          image_url = rs.symbol_image.url(:medium)
          rs.update_attributes(:image_url => image_url)
        end
      end
    #Dir.entries("/home/prabhanshu/Downloads/olamundo image 9th april/olamundo image 9th april/CategoryImages").each do |image_name|
    #       c = 0
    #  Category.all.each do |cat|
    #    if cat.category_image_file_name == image_name
    #      puts "c = #{c}"
    #      image_file = File.open("/home/prabhanshu/Downloads/olamundo image 9th april/olamundo image 9th april/CategoryImages/#{image_name}")
    #      cat.update_attributes(:category_image => image_file)
    #      image_file.close
    #      image_url = cat.category_image.url(:medium)
    #      cat.update_attributes(:image_url => image_url)
    #      c = c + 1
    #    end
    #  end
    end
    end
  end