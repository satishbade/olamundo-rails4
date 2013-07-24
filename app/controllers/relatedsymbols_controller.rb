class RelatedsymbolsController < ApplicationController

  respond_to :html ,:json
  layout :resolve_layout

  def index
    @relatedsymbols = Relatedsymbol.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @relatedsymbols }
    end
  end

  def show
    @relatedsymbol = Relatedsymbol.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @relatedsymbol }
    end
  end

  def new
    @symbol = Symbol1.find(params[:id])

    if params[:word]
      session[:word]= params[:word]
    end

    @relatedsymbol = @symbol.relatedsymbols.build
    @related_symbols = Symbol1.find(params[:id]).relatedsymbols.order("sequence asc")
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @relatedsymbol }
    end
  end

  def edit
    @relatedsymbol = Relatedsymbol.find(params[:id])
    @sequence_select = Array.new
    @symbol_sequence = Relatedsymbol.find_all_by_symbol1_id(@relatedsymbol.symbol1_id)
    @symbol_sequence.each do |cat|
      @sequence_select <<  cat.sequence
    end

    render :layout=>false
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
    #if params[:relatedsymbol][:symbol_image]
    #  update_image_file_name(params[:relatedsymbol][:symbol_image].original_filename)
    #  if @total_count.length > 0
    #    params[:relatedsymbol][:symbol_image].original_filename = "#{@total_count.length}" + "_" + params[:relatedsymbol][:symbol_image].original_filename
    #    puts"image_file_name:::::::::: #{params[:relatedsymbol][:symbol_image].original_filename.inspect}"
    #  end
    #end

    if params[:relatedsymbol][:symbol_image]
      params[:relatedsymbol][:symbol_image].original_filename = params[:relatedsymbol][:symbol_image].original_filename[0..params[:relatedsymbol][:symbol_image].original_filename.index(".")-1] + "_" +
          "#{Time.now.to_i}" + params[:relatedsymbol][:symbol_image].original_filename[params[:relatedsymbol][:symbol_image].original_filename.index(".")..params[:relatedsymbol][:symbol_image].original_filename.length]
      puts"image_file_name:::::::::: #{params[:relatedsymbol][:symbol_image].original_filename.inspect}"
    end

    @relatedsymbol = Relatedsymbol.new(params[:relatedsymbol])

    @seq_count =  Relatedsymbol.find_all_by_symbol1_id(@relatedsymbol.symbol1_id).count + 1
    @relatedsymbol.sequence = @seq_count

    respond_to do |format|
      if @relatedsymbol.save
        if @relatedsymbol.symbol_image
          if @relatedsymbol.symbol_image_file_name != nil
            @relatedsymbol.image_url = @relatedsymbol.symbol_image.url(:original)
          else
            @relatedsymbol.image_url = nil
          end
          @relatedsymbol.save
        end
        rel_sym = URI.escape(@relatedsymbol.symbol_text.to_s)
        uri = URI.parse("https://www.googleapis.com/language/translate/v2?key=AIzaSyCBbvppipGCRgKlhYvaHgFjk7uU1nMuMLc&q=#{rel_sym}&source=en&target=iw")
        str = uri.read
        json_data = JSON.parse(str)
        hebrew_word = json_data["data"]["translations"].first["translatedText"]
        puts "json_data:::::#{hebrew_word}"
        @relatedsymbol.update_attribute(:hebrew, hebrew_word)

        format.html { redirect_to new_relatedsymbol_path(:id => @relatedsymbol.symbol1_id), notice: "Related symbol - (#{@relatedsymbol.symbol_text}) was successfully added." }
        format.json { render json: @relatedsymbol, status: :created, location: @relatedsymbol }
      else
        format.html { render action: "new" }
        format.json { render json: @relatedsymbol.errors, status: :unprocessable_entity }
      end
    end

    @cat_symbol =  Relatedsymbol.find_all_by_symbol1_id(@relatedsymbol.symbol1_id)
    if params[:select_sequence]
      #@category.sequence = params[:select_sequence].to_i
      if @relatedsymbol.sequence >  params[:select_sequence].to_i
        @cat_symbol.each do |e_article|
          if e_article.sequence < @relatedsymbol.sequence  && e_article.sequence >= params[:select_sequence].to_i
            e_article.sequence = e_article.sequence + 1

          elsif e_article.sequence == @relatedsymbol.sequence
            e_article.sequence = params[:select_sequence].to_i
          end
          e_article.save
        end
      else
        @cat_symbol.each do |e_article|
          if @relatedsymbol.sequence < e_article.sequence && e_article.sequence <= params[:select_sequence].to_i
            e_article.sequence = e_article.sequence - 1
          elsif e_article.sequence == @relatedsymbol.sequence
            e_article.sequence = params[:select_sequence].to_i
          end
          e_article.save
        end
      end
    end

  end

  def update
    @relatedsymbol = Relatedsymbol.find(params[:id])

    #if params[:relatedsymbol][:symbol_image]
    #  update_image_file_name(params[:relatedsymbol][:symbol_image].original_filename)
    #  if params[:relatedsymbol][:symbol_image].original_filename
    #    if @total_count.length > 0  && @total_count.last.id != params[:id]
    #      params[:relatedsymbol][:symbol_image].original_filename = "#{@total_count.length}" + "_" + params[:relatedsymbol][:symbol_image].original_filename
    #      puts"image_file_name : #{params[:relatedsymbol][:symbol_image].original_filename.inspect}"
    #    end
    #  end
    #end

    if params[:relatedsymbol][:symbol_image]
      params[:relatedsymbol][:symbol_image].original_filename = params[:relatedsymbol][:symbol_image].original_filename[0..params[:relatedsymbol][:symbol_image].original_filename.index(".")-1] + "_" +
          "#{Time.now.to_i}" + params[:relatedsymbol][:symbol_image].original_filename[params[:relatedsymbol][:symbol_image].original_filename.index(".")..params[:relatedsymbol][:symbol_image].original_filename.length]
      puts"image_file_name:::::::::: #{params[:relatedsymbol][:symbol_image].original_filename.inspect}"
    end

    @cat_symbol =  Relatedsymbol.find_all_by_symbol1_id(@relatedsymbol.symbol1_id)
    if params[:select_sequence]
      #@category.sequence = params[:select_sequence].to_i
      if @relatedsymbol.sequence >  params[:select_sequence].to_i
        @cat_symbol.each do |e_article|
          if e_article.sequence < @relatedsymbol.sequence  && e_article.sequence >= params[:select_sequence].to_i
            e_article.sequence = e_article.sequence + 1

          elsif e_article.sequence == @relatedsymbol.sequence
            e_article.sequence = params[:select_sequence].to_i
          end
          e_article.save
        end
      else
        @cat_symbol.each do |e_article|
          if @relatedsymbol.sequence < e_article.sequence && e_article.sequence <= params[:select_sequence].to_i
            e_article.sequence = e_article.sequence - 1
          elsif e_article.sequence == @relatedsymbol.sequence
            e_article.sequence = params[:select_sequence].to_i
          end
          e_article.save
        end
      end
    end

    respond_to do |format|
      if @relatedsymbol.update_attributes(params[:relatedsymbol])
        if @relatedsymbol.symbol_image
          if @relatedsymbol.symbol_image_file_name != nil
            @relatedsymbol.update_attribute(:image_url, @relatedsymbol.symbol_image.url(:original))
          else
            @relatedsymbol.update_attribute(:image_url, nil)
          end
        end

        rel_sym = URI.escape(@relatedsymbol.symbol_text.to_s)
        uri = URI.parse("https://www.googleapis.com/language/translate/v2?key=AIzaSyCBbvppipGCRgKlhYvaHgFjk7uU1nMuMLc&q=#{rel_sym}&source=en&target=iw")
        str = uri.read
        json_data = JSON.parse(str)
        hebrew_word = json_data["data"]["translations"].first["translatedText"]
        puts "json_data:::::#{hebrew_word}"
        @relatedsymbol.update_attribute(:hebrew, hebrew_word)

        format.html { redirect_to new_relatedsymbol_path(:id => @relatedsymbol.symbol1_id), notice: "Related symbol was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @relatedsymbol.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_related_symbol
    @symbol = Symbol1.find(params[:id])
    @seq_count =  Relatedsymbol.find_all_by_symbol1_id(params[:id]).count + 1
    @sequence_select = Array.new
    @symbol_sequence = Relatedsymbol.find_all_by_symbol1_id(params[:id])
    @symbol_sequence.sort_by{|e| e[:sequence]}
    @symbol_sequence.each do |cat|
      @sequence_select <<  cat.sequence
    end
    @relatedsymbol = @symbol.relatedsymbols.build
    @relatedsymbol.sequence = @seq_count
    respond_with @relatedsymbol
  end

  def destroy
    @relatedsymbol = Relatedsymbol.find(params[:id])
    old_related_symbol = @relatedsymbol.symbol_text
    @relatedsymbol.destroy
    respond_to do |format|
      format.html { redirect_to new_relatedsymbol_path(:id => @relatedsymbol.symbol1_id), notice: "Related symbol - (#{old_related_symbol}) was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def get_updated_related_symbols
    puts "From::::::::::#{params[:update_from].inspect}"
    puts "To::::::::::#{Time.now.inspect}"
    related_symbols = Relatedsymbol.updated_related_symbols(params[:update_from])
    if related_symbols != nil
      respond_with related_symbols
    end
  end

  def resolve_layout
    case action_name
      when "add_related_symbol"
        "popup"
      else
        "application"
    end
  end

end
