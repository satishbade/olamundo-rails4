namespace :image_load do
  task :from_excel => :environment do
    require 'open-uri'
    require 'roo'
    @asset_dir = "#{Dir.getwd}/vendor/assets/source_list"
     puts @asset_dir

    @user = User.new
    @user.email = "skb_admin@ola-mundo.com"
    @user.password = "111111"
    @user.password_confirmation = "111111"
    @user.save
    @member = @user.members.build
    @member.relationship = "Brother"
    @member.name = "skb_admin"
    @member.save
    begin
      @source_file = Excel.new("#{@asset_dir}/pictogram_09.01.13.xls")
      cat_sequence = 0
      size = @source_file.sheets().size
      #@source_file.default_sheet = @source_file.sheet(2)
      counter = 0
      @source_file.sheets.each do |sheet|
        if counter > 0
          @source_file.default_sheet = sheet
          puts "sheet name : #{sheet}"
          @category = @member.categories.build
          @category.category_name =   sheet.strip
          @category.sequence = Category.count + 1

          #cat_sequence += 1
          file = @category.category_name
          Dir.entries("/home/motif/Ola-Mundo-Image/Archive").each do |file_name|
            if file_name.include?(file)
              image_file = File.open("/home/motif/Ola-Mundo-Image/Archive/#{file_name}")
              @category.category_image =  image_file
              image_file.close
              puts" category_image file name : #{@category.category_image}"
              break
            end
          end
          @category.save

          puts "category_no : #{@category.id}"
          puts @category.inspect
          sym_sequence = 0
          image_counter = 0
          if image_counter < 10
          2.upto(@source_file.last_row) do |line|
            @symbol = @category.symbol1s.build
            @symbol.word = @source_file.cell(line,'B').to_s
            if @symbol.word.include?(".0")
              @symbol.word = @symbol.word.split(".0")[0]
            end
            file = @source_file.cell(line,'C')
            @symbol.sequence = Symbol1.find_all_by_category_id(@category.id).count + 1
            #sym_sequence += 1

            begin
              Dir.entries("/home/motif/Ola-Mundo-Image/image107x107").each do |file_name|
                if file_name.eql? file
                  image_file = File.open("/home/motif/Ola-Mundo-Image/image107x107/#{file}")
                  @symbol.symbol_image = image_file
                  #puts "symbol_image : #{@symbol.symbol_image}"
                  image_file.close
                  image_counter += 1
                  break

                end
              end
              @symbol.save
              4.upto(@source_file.last_column) do |col|
                @related_symbol = @symbol.relatedsymbols.build
                if @source_file.cell(line, col) != nil
                  @related_symbol.symbol_text = @source_file.cell(line, col)
                  @related_symbol.sequence = Relatedsymbol.find_all_by_symbol1_id(@symbol.id).count + 1
                  @related_symbol.save
                end
                #related_symbol = @source_file.cell(line,col)
              end
              puts "-----------------------------------------------------------------------------------"

              if @symbol.symbol_image
                @symbol.image_url = @symbol.symbol_image.url(:original)
                @symbol.save
              end

                #image_file = File.open("/home/motif/Ola-Mundo-Image/image107x107/#{file}")
                #@symbol.image = image_file
            rescue
              puts "either image not available or no image name in excel sheet"
            end
          end #end of line
          end
        end  # end of counter
        puts "new sheet"
        counter = counter + 1
        puts "sheet : #{counter}"
      end   # end of sheet

    end     # end of outer begin

  end
end