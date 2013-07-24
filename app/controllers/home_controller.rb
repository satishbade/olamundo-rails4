class HomeController < ApplicationController
  require 'fileutils'
  #require 'iconv'
  layout :resolve_layout

  def index
    @user = current_user.members.order("id asc").all
  end

  def new
    no = 1
    if params[:no]
      params[:no].each do |seq|
        symbol = Symbol1.find(seq)
        symbol.sequence = no
        no = no + 1
        symbol.save
      end
    end
  end

  def bulk_upload
    @asset_dir = "#{Dir.getwd}/vendor/assets"
    @output_file = "#{@asset_dir}/output/bulk_upload.txt"
    File.open("#{@output_file}", 'w') { |f|
      f.puts "New Process at #{Time.now}"
      f.puts "--------------------------------------------------"
    }
    File.open("#{@output_file}", 'a+') do |f|
    excel = params[:excel]
    category = params[:files]
    symbol = params[:symbols]
    member = Member.where(:user_id => current_user.id).order("id").first
    if excel && category
      tmp = params[:excel].tempfile
      file = File.join("public", params[:excel].original_filename)
      FileUtils.cp tmp.path, file
      @source_file = Excel.new(file)
      @source_file.sheets.each do |sheet|
        @source_file.default_sheet = sheet
        @category = member.categories.build
        @category.category_name = sheet.strip
        file1 = @category.category_name
        f.puts "Category name #{file1}"
        category.each do |image|
          file_name = image.original_filename
          if file_name.include?(file1)
            image_file = File.open(image.path)
            @category.category_image = image_file
            image_file.close
            f.puts "Category #{file1} saved successfully"
            break
          end
        end
        @category.save
        2.upto(@source_file.last_row) do |line|
        @symbol = @category.symbol1s.build
        @symbol.word = @source_file.cell(line, 'B')
        file = @source_file.cell(line,'C')
        if file
          f.puts "symbol name #{file}"
           symbol.each do |file_name|
            puts "symbol name #{file_name.original_filename}"
            file_name1 = file_name.original_filename
            if file_name1.eql?(file)
              image_file = File.open(file_name.path)
              @symbol.symbol_image = image_file
              image_file.close
              break
            end
          end
          @symbol.save
          if @symbol.symbol_image.url.include?("missing")
            f.puts "either image not available or no image name in excel sheet"
           else
            f.puts "symbol name #{@symbol.symbol_image.url} saved successfully"
          end
         end
         end
        end
          #puts "Symbol saved successfully:::::::::::::::::::::::#{@symbol.inspect}"
          #4.upto(@source_file.last_column) do |col|
          #  @related_symbol = @symbol.relatedsymbols.build
          #  if @source_file.cell(line, col)
          #    @related_symbol.symbol_text = @source_file.cell(line, col)
          #    @related_symbol.sequence = Relatedsymbol.find_all_by_symbol1_id(@symbol.id).count + 1
          #    @related_symbol.save
          #  end
          #  #related_symbol = @source_file.cell(line,col)
          #end
          f.puts "-----------------------------------------------------------------------------------"

          #if @symbol.symbol_image
          #  @symbol.image_url = @symbol.symbol_image.url(:original)
          #  @symbol.save
          #end

        #rescue
        #  f.puts "either image not available or no image name in excel sheet"
        #end
        #end
        #end
        #end
        puts "-------------------------------------------------"
       f.puts @category.category_image.url
        puts "-------------------------------------------------"
      end
    end
  end

  def family_list
    family_lists = User.order("email asc").all
    @family = Kaminari.paginate_array(family_lists).page(params[:page])
    @relationship = [["Aunt", "Aunt"], ["Brother", "Brother"], ["Dad", "Dad"], ["Daughter", "Daughter"], ["Husband", "Husband"],
                     ["Mom", "Mom"], ["Nephew", "Nephew"], ["Niece", "Niece"], ["Sister", "Sister"], ["Son", "Son"], ["Uncle", "Uncle"], ["Wife", "Wife"]]
  end

  def delete_user
    if params[:account]
      User.find(params[:account]).destroy
      flash[:notice] = "User Account successfully deleted"
      redirect_to family_lists_path
    end
  end


  def resolve_layout
    case action_name
      when "home_page"
        "home_layout"
      else
        "application"
    end
  end


end
