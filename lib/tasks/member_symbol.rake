namespace :image_load do
  task :for_each_member => :environment do
    require 'open-uri'
    require 'roo'
    @asset_dir = "#{Dir.getwd}/vendor/assets/source_list"
    puts @asset_dir
    resource = Member.find(ENV["resource"])
    begin
      @source_file = Excel.new("#{@asset_dir}/pictogram_05.12.12.xls")
      puts "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
      cat_seq = 0
      symbol_seq = 0
      size = @source_file.sheets().size
      #@source_file.default_sheet = @source_file.sheet(2)
      counter = 0
      @source_file.sheets.each do |sheet|
        if counter > 0
          @source_file.default_sheet = sheet
          puts "sheet name : #{sheet}"
          @category = resource.categories.build
          @category.category_name =   sheet
          @category.category_name = @category.category_name.gsub(/\s+/, "")
          @category.sequence = cat_seq
          cat_seq += 1
          file = @category.category_name

          Dir.entries("/home/motif/Ola-Mundo-Image/Archive").each do |file_name|
            if file_name.include?(file)
            image_file = File.open("/home/motif/Ola-Mundo-Image/Archive/#{file_name}")
            @category.category_image =  image_file
            image_file.close
            puts" category file name : #{file}"
            @category.save
              break
            end
          end
          puts @category.inspect
          counter_for_image = 0
          2.upto(@source_file.last_row) do |line|

            @symbol = @category.symbol1s.build
            @symbol.word = @source_file.cell(line,'B')
            file = @source_file.cell(line,'C')
            @symbol.sequence = symbol_seq
            symbol_seq += 1

            puts file
            puts  "/home/motif/Pictogram images - 107x107/#{file}"
           if counter_for_image < 10
            begin
              Dir.entries("/home/motif/Ola-Mundo-Image/image107x107").each do |file_name|

                if file_name.eql? file
                  counter_for_image = counter_for_image + 1
                  puts "--------------------------------------------------"
                  image_file = File.open("/home/motif/Ola-Mundo-Image/image107x107/#{file}")
                  @symbol.symbol_image = image_file
                  image_file.close

                  break
                end
              end

                #image_file = File.open("/home/motif/Ola-Mundo-Image/image107x107/#{file}")
                #@symbol.image = image_file
            rescue
              puts "either image not available or no image name in excel sheet"
            end

            @symbol.save
           else
             break
           end



          end #end of line

        end  # end of counter
        puts "new sheet"
        puts "======================================================================"
        counter = counter + 1
        puts "sheet : #{counter}"
      end   # end of sheet

    end     # end of outer begin






  end
end