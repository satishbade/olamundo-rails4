namespace :update_duplicate_symbols do
  task :by_name => :environment do
    puts "Total symbols - #{Symbol1.count}"
    puts "Total unique symbols - #{Symbol1.select("DISTINCT word").count}"
    puts "Total duplicate symbols - #{Symbol1.select("word").group(:word).having("count(word) > 1").length}"
     File.open("updatedduplicatesymbol_file.txt" ,"a+") do |file|
      uniq_symbols =  Symbol1.select("DISTINCT word")
    # loop on all unique symbols
       uniq_symbols.each do |uniq_symbol|
         duplicate_symbols = Symbol1.find_all_by_word(uniq_symbol.word)
         uniq_symbol = Symbol1.find_by_word(uniq_symbol.word)
    # if duplicate exists
    # print id, word, image for each dulplicate
         if duplicate_symbols.length > 1
           c = 0
           duplicate_symbols.each do |dup_symbol|
              if  c > 0
                if dup_symbol.symbol_image_file_name == uniq_symbol.symbol_image_file_name
                  cat_name = Category.find(dup_symbol.category_id).category_name
                  dup_symbol.update_attributes(:symbol_image_file_name => "#{cat_name}_#{dup_symbol.symbol_image_file_name}")

                 file.write " #{dup_symbol.id}=>#{dup_symbol.word}(#{Category.find(dup_symbol.category_id).category_name})=>#{dup_symbol.symbol_image_file_name}"
                 file.write "\n"
                end
              end
             #c = c + 1
             #if dup_symbol.symbol_image_file_name.split(".").last != "png"
             #  if dup_symbol.symbol_type == "Picture"
             #  file_name = "Picture_" + dup_symbol.symbol_image_file_name.split(".").first + ".png"
             #  else
             #    file_name =  Category.find(dup_symbol.category_id).category_name + "_" + dup_symbol.symbol_image_file_name.split(".").first + ".png"
             #  end
             #  ext = dup_symbol.image_url.split("/").last.split("?").first.split(".").last
             #  img_url = dup_symbol.image_url.gsub("#{ext}" ,"png")
             #  dup_symbol.update_attributes(:symbol_image_file_name => file_name ,:image_url => img_url)
             #end
           end
         end
       end
      end

    ## category_duplicate_images_with_symbol_image
       Category.all.each do |cat|
         category_image = cat.category_name + ".png"
         symbol = Symbol1.where('lower(symbol_image_file_name) = ?',category_image.downcase)
          if symbol.length > 0
            symbol.each do |s|
               image_file_name = cat.category_name + "_" + s.symbol_image_file_name
               s.update_attributes(:symbol_image_file_name => image_file_name  )
            end
          end
       end


    #  related symbol duplicate
    Symbol1.all.each do |symbol|
      related_symbol = Relatedsymbol.where('lower(symbol_image_file_name) = ?',symbol.symbol_image_file_name)
      if related_symbol.length > 0
        related_symbol.each do |r|
          related_symbol_image_file_name = symbol.symbol_image_file_name.split(".").first + "_" + r.symbol_image_file_name
          r.update_attributes(:symbol_image_file_name => related_symbol_image_file_name  )
        end
      end
    end




  end
end

