class Symbol1sController < ApplicationController

  respond_to :html, :json
  layout :resolve_layout

  skip_before_filter :verify_authenticity_token
  def index
    if (params[:search] &&  params[:search].length > 0)
      #if params[:search].length > 0
      @symbol1s = Symbol1.search(params[:search])
      if (@symbol1s.size > 0  && @symbol1s[0].word == params[:search])
        render 'search' ,:local => @symbol1s
      else
        @category_count = Category.count()

        @category_page_all =  Category.order("sequence asc").all
        if params[:id]
          session[:no] = params[:no].to_s
          session[:cat_id] = params[:id]
          @symbol1s = Symbol1.where(:category_id => params[:id]).order("sequence asc")
          puts @symbol1s.count
          @symbol1s.each do |as|
            puts as.inspect
          end
        else
          if session[:cat_id] == nil
            if  Category.first
              session[:cat_id] =  Category.find_by_sequence(1)
              params[:id] =  session[:cat_id]
              session[:no] = params[:no]
              @symbol1s = Symbol1.where(:category_id => params[:id]).order("sequence asc")
            end
          else
            if @symbol1s
              params[:id] = session[:cat_id]
              @symbol1s = Symbol1.where(:category_id => session[:cat_id]).order("sequence asc")
            end
          end
        end
        flash[:notice] = "Symbol - #{params[:search]} doesn't exist."
      end
    else
      if session[:word] == nil
      @category_count = Category.count()

      @category_page_all =  Category.order("sequence asc").all
      if params[:id]
        session[:no] = params[:no].to_s
        session[:cat_id] = params[:id]
        @symbol1s = Symbol1.where(:category_id => params[:id]).order("sequence asc")
        puts @symbol1s.count
        @symbol1s.each do |as|
          puts as.inspect
        end
      else
        if session[:cat_id] == nil
            if  Category.first
            session[:cat_id] =  Category.find_by_sequence(1)
            params[:id] =  session[:cat_id]
            session[:no] = params[:no]
            @symbol1s = Symbol1.where(:category_id => params[:id]).order("sequence asc")
            end
        else
          #if @symbol1s
            params[:id] = session[:cat_id]
             @symbol1s = Symbol1.where(:category_id => session[:cat_id]).order("sequence asc")
          #end
        end
      end
     #if @symbol1s
     #   @symbol1s =  Kaminari.paginate_array(@symbol1s).page(params[:page]).per(36)

      respond_with @symbol1s
      puts "params[:id]  #{params[:id].inspect}"
      puts "session[:cat_id]  #{session[:cat_id].inspect}"
      else
        @symbol1s = Symbol1.search(session[:word])
        session[:word]= nil
        render "search" ,:local => @symbol1s
      end
    end
  end



  def new
    @seq_count =  Symbol1.find_all_by_category_id(session[:cat_id]).count + 1
    @sequence_select = Array.new
    @symbol_sequence = Symbol1.find_all_by_category_id(session[:cat_id])
    @symbol_sequence.sort_by{|e| e[:sequence]}
    @symbol_sequence.each do |cat|
      @sequence_select <<  cat.sequence
    end
    @symbol = Symbol1.new
    @symbol.sequence = @seq_count
    session[:cat_name] = params[:category_name]
    1.times do
      @symbol.relatedsymbols.build
    end
    respond_with(@symbol)
  end

  def update_image_file_name(file_name)
    puts"image_file_name : #{file_name.inspect}"
    categories_count = Category.where("category_image_file_name like ?", "#{file_name}")
    symbols_count = Symbol1.where("symbol_image_file_name like ?", "%#{file_name}")
    related_symbols_count = Relatedsymbol.where("symbol_image_file_name like ?", "%#{file_name}")
    @total_count = categories_count + symbols_count + related_symbols_count
    puts @total_count.length
  end

  def create
    @seq_count =  Symbol1.find_all_by_category_id(session[:cat_id]).count + 1

    #if params[:symbol1][:symbol_image]
    #  update_image_file_name(params[:symbol1][:symbol_image].original_filename)
    #  if @total_count.length > 0
    #    params[:symbol1][:symbol_image].original_filename = "#{@total_count.length}" + "_" + params[:symbol1][:symbol_image].original_filename
    #    puts"image_file_name:::::::::: #{params[:symbol1][:symbol_image].original_filename.inspect}"
    #  end
    #end

    if params[:symbol1][:symbol_image]
      params[:symbol1][:symbol_image].original_filename = params[:symbol1][:symbol_image].original_filename[0..params[:symbol1][:symbol_image].original_filename.index(".")-1] + "_" +
          "#{Time.now.to_i}" + params[:symbol1][:symbol_image].original_filename[params[:symbol1][:symbol_image].original_filename.index(".")..params[:symbol1][:symbol_image].original_filename.length]
      puts"image_file_name:::::::::: #{params[:symbol1][:symbol_image].original_filename.inspect}"
  end

    @symbol_param = Symbol1.new(params[:symbol1])
    @symbol_param.sequence = @seq_count
    respond_with(@symbol_param) do |format|
      if @symbol_param.save
        @params_cat = session[:cat_id]
        @symbol_param.category_id =  session[:cat_id]
        if @symbol_param.symbol_image
          if @symbol_param.symbol_image_file_name != nil
            puts "IMAGE_URL_BEFORE::::::::::::#{@symbol_param.symbol_image.url(:original)}"
            @symbol_param.image_url = @symbol_param.symbol_image.url(:original)
            puts "IMAGE_URL_AFTER::::::::::::#{@symbol_param.image_url}"
          else
            @symbol_param.image_url = nil
          end
        end
        sym_word = URI.escape(@symbol_param.word.to_s)
        uri = URI.parse("https://www.googleapis.com/language/translate/v2?key=AIzaSyCBbvppipGCRgKlhYvaHgFjk7uU1nMuMLc&q=#{sym_word}&source=en&target=iw")
        str = uri.read
        json_data = JSON.parse(str)
        @symbol_param.hebrew = json_data["data"]["translations"].first["translatedText"]
        @symbol_param.save
        SymbolBank.update_symbol_bank(@symbol_param)
        format.html { redirect_to symbol1s_path(:id => @params_cat ), notice: "New symbol - (#{@symbol_param.word}) was successfully added." }
        format.json { render json: @symbol_param, status: :created, location: @member }
      else
        format.html { render action: "new" }
        format.json { render json: @symbol_param.errors, status: :unprocessable_entity }
      end
    end

    @cat_symbol =  Symbol1.find_all_by_category_id(session[:cat_id])
    if params[:select_sequence]
      #@category.sequence = params[:select_sequence].to_i
      if @symbol_param.sequence >  params[:select_sequence].to_i
        @cat_symbol.each do |symbol_seq|
          if symbol_seq.sequence < @symbol_param.sequence  && symbol_seq.sequence >= params[:select_sequence].to_i
            symbol_seq.sequence = symbol_seq.sequence + 1

          elsif symbol_seq.sequence == @symbol_param.sequence
            symbol_seq.sequence = params[:select_sequence].to_i
          end
          symbol_seq.save
        end
      else
        @cat_symbol.each do |symbol_seq|
          if @symbol_param.sequence < symbol_seq.sequence && symbol_seq.sequence <= params[:select_sequence].to_i
            symbol_seq.sequence = symbol_seq.sequence - 1
          elsif symbol_seq.sequence == @symbol_param.sequence
            symbol_seq.sequence = params[:select_sequence].to_i
          end
          symbol_seq.save
        end
      end
    end
  end

  def edit
    @symbol = Symbol1.find(params[:id])
    session[:symbol_word]  = @symbol.word
    session[:symbol_image]  = @symbol.image_url
    @sequence_select = Array.new
    @symbol_sequence = Symbol1.find_all_by_category_id(session[:cat_id])
    #@symbol_sequence.sort_by{|e| e[:sequence]}
    @symbol_sequence.each do |cat|
      @sequence_select <<  cat.sequence
    end
    puts @sequence_select.inspect
    render :layout=>false
  end

  def update
    @cat_symbol =  Symbol1.find_all_by_category_id(session[:cat_id])
    @symbol = Symbol1.find(params[:id])

    #if params[:symbol1][:symbol_image]
    #  update_image_file_name(params[:symbol1][:symbol_image].original_filename)
    #  if params[:symbol1][:symbol_image].original_filename
    #    if @total_count.length > 0  && @total_count.last.id != params[:id]
    #      params[:symbol1][:symbol_image].original_filename = "#{@total_count.length}" + "_" + params[:symbol1][:symbol_image].original_filename
    #      puts"image_file_name : #{params[:symbol1][:symbol_image].original_filename.inspect}"
    #    end
    #  end
    #end

    if params[:symbol1][:symbol_image]
      params[:symbol1][:symbol_image].original_filename = params[:symbol1][:symbol_image].original_filename[0..params[:symbol1][:symbol_image].original_filename.index(".")-1] + "_" +
          "#{Time.now.to_i}" + params[:symbol1][:symbol_image].original_filename[params[:symbol1][:symbol_image].original_filename.index(".")..params[:symbol1][:symbol_image].original_filename.length]
      puts"image_file_name:::::::::: #{params[:symbol1][:symbol_image].original_filename.inspect}"
    end

    if params[:select_sequence]
      #@category.sequence = params[:select_sequence].to_i
      if @symbol.sequence >  params[:select_sequence].to_i
        @cat_symbol.each do |symbol_seq|
          if symbol_seq.sequence < @symbol.sequence  && symbol_seq.sequence >=params[:select_sequence].to_i
            symbol_seq.sequence = symbol_seq.sequence + 1
          elsif symbol_seq.sequence == @symbol.sequence
            symbol_seq.sequence = params[:select_sequence].to_i
          end
          symbol_seq.save
        end
      else
        @cat_symbol.each do |symbol_seq|
          if @symbol.sequence < symbol_seq.sequence && symbol_seq.sequence <= params[:select_sequence].to_i
            symbol_seq.sequence = symbol_seq.sequence - 1
          elsif symbol_seq.sequence == @symbol.sequence
            symbol_seq.sequence = params[:select_sequence].to_i
          end
          symbol_seq.save
        end
      end
    end

    respond_with(@symbol) do |format|
      if @symbol.update_attributes(params[:symbol1])
        if @symbol.symbol_image
          if @symbol.symbol_image_file_name != nil
            @symbol.update_attribute(:image_url, @symbol.symbol_image.url(:original))
          else
            @symbol.update_attribute(:image_url, nil)
          end
        end
        sym_word = URI.escape(@symbol.word.to_s)
        uri = URI.parse("https://www.googleapis.com/language/translate/v2?key=AIzaSyCBbvppipGCRgKlhYvaHgFjk7uU1nMuMLc&q=#{sym_word}&source=en&target=iw")
        str = uri.read
        json_data = JSON.parse(str)
        hebrew_word = json_data["data"]["translations"].first["translatedText"]
        puts "json_data:::::#{hebrew_word}"
        @symbol .update_attribute(:hebrew, hebrew_word)

        format.html { redirect_to symbol1s_path(:id => session[:cat_id]), notice: "Symbol was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @symbol.errors, status: :unprocessable_entity }
      end
    end
    related_symbols = Relatedsymbol.where("symbol1_id = ? and symbol_text =?", @symbol.id, session[:symbol_word]).first
    if  related_symbols
      related_symbols.symbol_text = @symbol.word
      related_symbols.symbol_image = @symbol.symbol_image
      related_symbols.save
    end
  end

   def show
     @symbol = Symbol1.find(params[:id])
     respond_with @symbol
   end

  def destroy
    @symbol = Symbol1.find(params[:id])
    old_symbol = @symbol.word
    @symbol.destroy

    #@cat_sequence_decrease = Symbol1.find_by_category_id(session[:cat_id])
    @cat_sequence_decrease = Symbol1.where(:category_id => session[:cat_id]).order("sequence asc")
    puts  "sequence decrease #{@sequence_decrease.inspect}"
    no = 1
    @cat_sequence_decrease.sort_by{|e| e[:sequence]}
    @cat_sequence_decrease.each do |dec|
      puts "asdsad"
      puts  dec.sequence = no
      puts "asdsad"
      puts no = no + 1
      dec.save
    end

    respond_with(@symbol) do |format|
      format.html { redirect_to symbol1s_path(:id => session[:cat_id]),notice: "Symbol - (#{old_symbol}) was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def autoload_word        # written by ps
    @symbol1s = Symbol1.search1(params[:term])
    #@symbol1s = Symbol1.find(:all, :conditions => ['word LIKE ?', "#{params[:term]}%"])
    @symbol1s = @symbol1s.sort {|x,y| x[:word].downcase<=>y[:word].downcase}
    @symbol1s.each do |s|
      p s.word
    end
    @symbol1s = @symbol1s.first(5)
    puts "count #{@symbol1s.count}"
    puts "??????????????????????"
    @symbol1s.each do |s|
      p s.word
    end
    @words_hash = []
    @symbol1s.each do |s|
      @words_hash << { "label" => s.word }
    end
    respond_to do |format|
      format.html
      # Here is where you can specify how to handle the request for "/people.json"
      format.json { render :json => @words_hash }
    end
  end

  def bulk_symbol_upload
    symbol_banks = SymbolBank.all(:order => :symbol_name)
    @bank_symbols = Kaminari.paginate_array(symbol_banks).page(params[:page])

    session[:new_symbols] = Array.new
    puts "params[:symbols]:::::::::::#{params[:bulk_symbol_upload].inspect}"

    puts "params:::sysid::::#{params[:sys_ids].inspect}"

    if params[:bulk_symbol_upload] || params[:sys_ids]

      if params[:sys_ids]
        params[:sys_ids].each do |bank|
          sym_bank = SymbolBank.find_by_id(bank)
          puts "image.symbol_image::::::::::::::#{sym_bank.inspect}"
          @new_symbol = Symbol1.new
          @new_symbol.save(:validate => false)
          session[:new_symbols] << @new_symbol.id

          @new_symbol.word = sym_bank.symbol_name
          @new_symbol.symbol_image_file_name = sym_bank.symbol_image_file_name
          @new_symbol.symbol_image_content_type = sym_bank.symbol_image_content_type
          @new_symbol.symbol_image_file_size = sym_bank.symbol_image_file_size
          @new_symbol.symbol_image_updated_at = Time.now


          @new_symbol.image_url = sym_bank.image_url
          @new_symbol.symbol_type = "Symbol"
          @new_symbol.sequence = Symbol1.find_all_by_category_id(params[:category_id]).count + 1

          @cat = Category.find_by_sequence(1)
          @new_symbol.category_id = @cat.id

          @new_symbol.save
        end
      elsif params[:bulk_symbol_upload]
        symbol = params[:bulk_symbol_upload][:symbol_image]
        symbol.each do |image|
          puts "image.symbol_image::::::::::::::#{image.inspect}"
          @new_symbol = Symbol1.new
          #image_file = File.open(image.path)
          @new_symbol.symbol_image = image
          #image_file.close
          ori_file_name = image.original_filename
          puts "ori_file_name::::::::::::#{ori_file_name.inspect}"
          puts "image.original_filename :::::::::::::::::#{image.original_filename.inspect}"
          image.original_filename = image.original_filename[0..image.original_filename.index(".")-1] + "_" + "#{Time.now.to_i}" + image.original_filename[image.original_filename.index(".")..image.original_filename.length]
          @new_symbol.symbol_image_file_name = image.original_filename
          puts"image_file_name:::::::::: #{image.original_filename.inspect}"

          @new_symbol.save(:validate => false)
          session[:new_symbols] << @new_symbol.id

          @new_symbol.image_url = @new_symbol.symbol_image.url(:original)
          @new_symbol.symbol_type = "Symbol"
          @new_symbol.sequence = Symbol1.find_all_by_category_id(params[:category_id]).count + 1

          @cat = Category.find_by_sequence(1)
          @new_symbol.category_id = @cat.id

          @new_symbol.update_attribute(:word, ori_file_name[/.*(?=\..+$)/])

          SymbolBank.update_symbol_bank(@new_symbol)
        end
      end
      flash[:notice] = "Uploaded Successfully."
      redirect_to symbol_image_show_symbol1s_path
    #else
    #  puts "::::::::::::::IN ELSE:::::::::::"
    #  flash[:notice] = "Nothing to upload."
    #  redirect_to bulk_symbol_upload_path
    end
  end

  def symbol_image_show
    @category = Category.all(:order => :category_name).collect {|c| [c.category_name, c.id]}
  end

  def save_bulk_symbols
    symbol_details = params[:new]
  end

  def update_symbol
     if params[:symbol_id]
       @symbol = Symbol1.find(params[:symbol_id])
       if params[:symbol_text]
         @symbol.word = params[:symbol_text]
       end
       if params[:category_id]
         @symbol.category_id = params[:category_id]
       end
       if params[:symbol_type]
         @symbol.symbol_type = params[:symbol_type]
       end

       @symbol.save(:validate => false)
       puts "@symbol:::::::#{@symbol.inspect}"
       sym_bank = SymbolBank.find_by_symbol_image_file_name(@symbol.symbol_image_file_name)
       puts "sym_bank:::::::::::#{sym_bank.inspect}"
       if sym_bank
         sym_bank.update_attribute(:symbol_name, @symbol.word)
       end

     end
  end

  def delete_symbol
    @symbol_new = Symbol1.find(params[:symbol_id])
    session[:new_symbols].delete(params[:symbol_id].to_i)
    @symbol_new.destroy
    redirect_to symbol_image_show_symbol1s_path
  end

  def cancel_symbols_saving
    ses = session[:new_symbols]
    ses.each do |symbols|
      sym = Symbol1.find(symbols)
      sym.destroy
    end
    respond_with(@symbol_new, :location => bulk_upload_symbols_path, :notice => "You have cancelled the uploaded Symbols")
  end

  def get_all_symbols
    category = Category.find_by_category_name(params[:category_name])
    if category
      symbols = category.symbol1s_with_sequence
    end
    if symbols != nil
      respond_with(symbols, :include => :related_symbols_with_sequence)
    end
  end


  def delete_bulk_symbols
    bulk_symbols = params[:sys_ids]
    if bulk_symbols
      bulk_symbols.each do |symbol_id|
        sym = Symbol1.find(symbol_id.to_i)
        sym.destroy
      end
      @sym_sequence_sort = Symbol1.where(:category_id => session[:cat_id]).order("sequence asc")
      no = 1
      @sym_sequence_sort.sort_by{|e| e[:sequence]}
      @sym_sequence_sort.each do |seq|
        puts  seq.sequence = no
        puts no = no + 1
        seq.save
      end
      redirect_to symbol1s_path
      flash[:notice] = "Symbols successfully deleted"
    else
      redirect_to symbol1s_path
      flash[:notice] = "No Symbols selected"
    end
  end

  def get_updated_symbols
    puts "From::::::::::#{params[:update_from].inspect}"
    puts "To::::::::::#{Time.now.inspect}"
    symbols = Symbol1.updated_symbols(params[:update_from])
    if symbols != nil
      respond_with symbols
    end
  end

  def upload_file_from_ipad
    puts "Create method in Symbol Controller :::::;"
    @userfile      = params[:fileid]

    puts "@userfile:::::::::::::#{@userfile.inspect}"

    symbol1 = Symbol1.new
    symbol1.symbol_image = @userfile
    symbol1.word = "Shararth"
    symbol1.symbol_image_content_type = "image"
    symbol1.category_id = 1
    puts "before save :::::::; #{params[:symbol1].inspect}"
    symbol1.save(:validate => false)
    respond_with symbol1
  end

  def resolve_layout
    case action_name
      when "new"
        "popup"
      else
        "application"
    end
  end

end


