class CategoriesController < ApplicationController

  respond_to :html, :json
  layout :resolve_layout
  skip_before_filter :authenticate_user!, :only => [:get_category_symbols]
  include Symbol1sHelper
  helper_method :colors

  def index
    #@categories = Category.all
    #@category_names = Array.new
    #
    #@categories.each do |category|
    #  @category_names << category.category_name
    #end

    if params[:category]
      @category_name = params[:category]
    else
      @category_name = Category.first.category_name
    end

    @category = Category.find_by_category_name(@category_name)
    @symbols = Symbol1.find_all_by_category_id(@category.id)
    @symbol1s = Kaminari.paginate_array(@symbols).page(params[:page]).per(10)
    respond_with(@symbol1s)
  end

  def test_val
    @category_id = Category.find_by_category_name(params[:test_category]).id
    @symbols = Symbol1.find_all_by_category_id(@category_id)
  end

  def new
    @sequence_select = Array.new
    #color_no = rand(0..28)
    @category_sequence = Category.order("sequence asc").all
    @category_sequence.each do |cat|
      @sequence_select <<  cat.sequence
    end

    @new_sequence =  @category_sequence.count + 1
    @category = Category.new
    @category_sequence = increment_category_sequence
    @category.background_color =  nil
    respond_with(@category)
    #render :layout=>false
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
    puts "CATEGORY CREATE"
    #if params[:category][:category_image]
    #  if params[:category][:category_image].original_filename
    #    update_image_file_name(params[:category][:category_image].original_filename)
    #    if @total_count.length > 0
    #      params[:category][:category_image].original_filename = "#{@total_count.length}" + "_" + params[:category][:category_image].original_filename
    #      puts"image_file_name:::::::::: #{params[:category][:category_image].original_filename.inspect}"
    #    end
    #  end
    #end

    if params[:category][:category_image]
      params[:category][:category_image].original_filename = params[:category][:category_image].original_filename[0..params[:category][:category_image].original_filename.index(".")-1] + "_" +
          "#{Time.now.to_i}" + params[:category][:category_image].original_filename[params[:category][:category_image].original_filename.index(".")..params[:category][:category_image].original_filename.length]
      puts"image_file_name:::::::::: #{params[:category][:category_image].original_filename.inspect}"
    end

    @category = Category.new(params[:category])
    #@category.sequence = Category.count + 1
    @category.sequence = increment_category_sequence
    if @category.category_image
      if @category.category_image_file_name != nil
        @category.image_url = @category.category_image.url(:medium)
      else
        @category.image_url = nil
      end
    end
    respond_with(@category) do |format|
      if @category.save
        cat_name = URI.escape(@category.category_name.to_s)
        uri = URI.parse("https://www.googleapis.com/language/translate/v2?key=AIzaSyCBbvppipGCRgKlhYvaHgFjk7uU1nMuMLc&q=#{cat_name}&source=en&target=iw")
        str = uri.read
        json_data = JSON.parse(str)
        hebrew_word = json_data["data"]["translations"].first["translatedText"]
        puts "json_data:::::#{hebrew_word}"
        @category.update_attribute(:hebrew, hebrew_word)

        session[:cat_id] = @category.id
        format.html { redirect_to symbol1s_path, notice: "New Category - (#{@category.category_name}) was successfully Added." }
        format.json { render json: @category, status: :created, location: @member }
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end

    if params[:select_sequence]
      #@category.sequence = params[:select_sequence].to_i
      if @category.sequence >  params[:select_sequence].to_i
        Category.all.each do |e_article|
          if e_article.sequence < @category.sequence  && e_article.sequence >=params[:select_sequence].to_i
            e_article.sequence = e_article.sequence + 1

          elsif e_article.sequence == @category.sequence
            e_article.sequence = params[:select_sequence].to_i
          end
          e_article.save
        end
      else
        Category.all.each do |e_article|
          if @category.sequence < e_article.sequence && e_article.sequence <= params[:select_sequence].to_i
            e_article.sequence = e_article.sequence - 1
          elsif e_article.sequence == @category.sequence
            e_article.sequence = params[:select_sequence].to_i
          end
          e_article.save
        end
      end
    end

  end

  def edit
    @category = Category.find(params[:id])
     @sequence_select = Array.new
    @category_sequence = Category.order("sequence asc").all
    @category_sequence.each do |cat|
      @sequence_select <<  cat.sequence
    end
    puts @sequence_select.inspect
  end

  def update
    @category = Category.find(params[:id])

    #if params[:category][:category_image]
    #  if params[:category][:category_image].original_filename
    #    update_image_file_name(params[:category][:category_image].original_filename)
    #    if @total_count.length > 0 && @total_count.last.id != params[:id]
    #      params[:category][:category_image].original_filename = "#{@total_count.length}" + "_" + params[:category][:category_image].original_filename
    #      puts "image_file_name : #{params[:category][:category_image].original_filename.inspect}"
    #    end
    #  end
    #end

    if params[:category][:category_image]
      params[:category][:category_image].original_filename = params[:category][:category_image].original_filename[0..params[:category][:category_image].original_filename.index(".")-1] + "_" +
          "#{Time.now.to_i}" + params[:category][:category_image].original_filename[params[:category][:category_image].original_filename.index(".")..params[:category][:category_image].original_filename.length]
      puts"image_file_name:::::::::: #{params[:category][:category_image].original_filename.inspect}"
    end

    if params[:select_sequence]
      #@category.sequence = params[:select_sequence].to_i
      if @category.sequence >  params[:select_sequence].to_i
        Category.all.each do |e_article|
          if e_article.sequence < @category.sequence  && e_article.sequence >=params[:select_sequence].to_i
            e_article.sequence = e_article.sequence + 1

          elsif e_article.sequence == @category.sequence
            e_article.sequence = params[:select_sequence].to_i
          end
          e_article.save
        end
      else
        Category.all.each do |e_article|
          if @category.sequence < e_article.sequence && e_article.sequence <= params[:select_sequence].to_i
            e_article.sequence = e_article.sequence - 1
          elsif e_article.sequence == @category.sequence
            e_article.sequence = params[:select_sequence].to_i
          end
          e_article.save
        end
      end
    end

    count = Symbol1.find_all_by_category_id(session[:cat_id]).count + 1
    if params[:category][:symbol1s_attributes]
      params[:category][:symbol1s_attributes].values.each do |item|
        puts item[:sequence] = count
        count+=1

        #if item[:symbol_image]
        #  if item[:symbol_image].original_filename
        #    update_image_file_name(item[:symbol_image].original_filename)
        #    if @total_count.length > 0 && @total_count.last.id != params[:id]
        #      item[:symbol_image].original_filename = "#{@total_count.length}" + "_" + item[:symbol_image].original_filename
        #      puts "image_file_name :::::::::::::: #{item[:symbol_image].original_filename}"
        #    end
        #  end
        #end

        if item[:symbol_image]
          item[:symbol_image].original_filename = item[:symbol_image].original_filename[0..item[:symbol_image].original_filename.index(".")-1] + "_" +
              "#{Time.now.to_i}" + item[:symbol_image].original_filename[item[:symbol_image].original_filename.index(".")..item[:symbol_image].original_filename.length]
          puts"image_file_name:::::::::: #{item[:symbol_image].original_filename.inspect}"
        end
      end
      respond_with(@category) do |format|
        puts "params[:category]:::::::::::::::#{params[:category].inspect}"
        if @category.update_attributes(params[:category])
          params[:category][:symbol1s_attributes].values.each do |item|
            if item[:symbol_image]
              sym_url = Symbol1.where(:symbol_image_file_name => item[:symbol_image].original_filename)
              sym_url.each do |url|
                puts "url:::::::::::::#{url.inspect}"
                url.image_url = url.symbol_image.url(:original)
                puts "url.image_url:::::::::::#{url.image_url.inspect}"
                if url.symbol_image_file_name != nil
                  url.update_attribute(:image_url, url.image_url)
                else
                  url.update_attribute(:image_url, nil)
                end
                SymbolBank.update_symbol_bank(url)
              end
            end
          end

          format.html { redirect_to symbol1s_path(:id => params[:id]), notice: 'Symbols were successfully added.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @category.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_with(@category) do |format|
        if @category.update_attributes(params[:category])
          if @category.category_image
            if @category.category_image_file_name != nil
              @category.update_attribute(:image_url, @category.category_image.url(:medium))
            else
              @category.update_attribute(:image_url, nil)
            end
          end
          cat_name = URI.escape(@category.category_name.to_s)
          uri = URI.parse("https://www.googleapis.com/language/translate/v2?key=AIzaSyCBbvppipGCRgKlhYvaHgFjk7uU1nMuMLc&q=#{cat_name}&source=en&target=iw")
          str = uri.read
          json_data = JSON.parse(str)
          hebrew_word = json_data["data"]["translations"].first["translatedText"]
          puts "json_data:::::#{hebrew_word}"
          @category.update_attribute(:hebrew, hebrew_word)

          format.html { redirect_to symbol1s_path(:id => params[:id]), notice: "Category was successfully updated." }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @category.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def show
    @category = Category.find(params[:id])
    @symbols = Symbol1.find_all_by_category_id(@category.id)
    @symbol1s = Kaminari.paginate_array(@symbols).page(params[:page]).per(5)
    respond_with(@category)
  end

  def add_bulk_symbol
    @category = Category.find(session[:cat_id])
    1.times do
      @category.symbol1s.build
    end
    @cat_sequence = @category.symbol1s.count + 1
    respond_with(@category, notice: 'Category was successfully updated.')
  end

  def destroy
    @category = Category.find(params[:id])
    old_category = @category.category_name
    @category.destroy
    @sequence_decrease = Category.order("sequence asc").all
    no = 1
    @sequence_decrease.each do |dec|
      dec.sequence = no
      no = no + 1
      dec.save
    end

    session[:cat_id] = nil
    if Category.first
      session[:cat_id] = Category.find_by_sequence(1)
    end
    respond_with(@category) do |format|
      format.html { redirect_to symbol1s_path(:id => session[:cat_id]), notice: "Category - (#{old_category}) was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def resolve_layout
    case action_name
      when "new", "edit"
        "popup"
      else
        "application"
    end
  end

  def increment_category_sequence
    @category.increment_category_sequence
  end

  def get_category_symbols
    category = Category.where(:default_skb => true).all(:order => :sequence)
    respond_with(category, :include => { :symbol1s_with_sequence => {:include => :related_symbols_with_sequence}})
    #respond_with(category, :only => [:id, :category_name, :sequence, :category_image_file_name, :image_url, :background_color], :include => { :symbol1s_with_sequence => {:only => [:id, :word, :sequence, :image_url, :symbol_type, :symbol_image_file_name], :include => {:related_symbols_with_sequence => {:only => [:id, :symbol_text, :image_url, :sequence, :symbol_image_file_name]}}}})
  end

  def get_all_categories
    category = Category.all(:order => :sequence)
    if category != nil
      respond_with category
    end
  end

  def get_updated_categories
    puts "From::::::::::#{params[:update_from].inspect}"
    puts "To::::::::::#{Time.now.inspect}"
    category = Category.updated_categories(params[:update_from])
    if category != nil
      respond_with category
    end
  end

  def get_updated_categories_symbols
    puts "From::::::::::#{params[:update_from].inspect}"
    puts "To::::::::::#{Time.now.inspect}"
    has_updated_categories_symbols = Array.new
    categories = Category.all(:order => :sequence)
    categories.each do |category|
      symbols = Symbol1.where("updated_at > ? and category_id = ?", params[:update_from], category.id).order(:sequence)
      @sym_attr = Array.new

      #cat_attr = category.attributes
      symbols.each do |symbol|
        sym_atr = symbol.attributes
        puts "sym_atr::::::::::::#{sym_atr.inspect}"
        related_symbols = Relatedsymbol.where("updated_at > ? and symbol1_id = ?", params[:update_from].to_datetime, symbol.id).order(:sequence)

        sym_atr["related_symbols_with_sequence"] = related_symbols
        @sym_attr << sym_atr
      end

      if (category.updated_at > params[:update_from] && category.updated_at < Time.now) || symbols.count > 0
        cat_attr = category.attributes
        cat_attr["symbol1s_with_sequence"] = @sym_attr
        has_updated_categories_symbols << cat_attr
      end
    end
    respond_with has_updated_categories_symbols
  end

  def get_categories_color
    background_color = Category.order(:sequence).pluck(:background_color)
    if background_color != nil
      respond_with background_color
    end
  end


end
