class SymbolBanksController < ApplicationController

  respond_to :html, :json



  # GET /symbol_banks
  # GET /symbol_banks.json
  def index
    puts "Params Page::::::::::#{params[:page]}"
    symbol_banks = SymbolBank.all(:order => :symbol_name)
    session[:page] = params[:page]
    @symbol_banks = Kaminari.paginate_array(symbol_banks).page(params[:page])
    respond_with @symbol_banks
  end

  # GET /symbol_banks/1
  # GET /symbol_banks/1.json
  def show
    @symbol_bank = SymbolBank.find(params[:id])
    respond_with @symbol_bank
  end

  # GET /symbol_banks/new
  # GET /symbol_banks/new.json
  def new
    @symbol_bank = SymbolBank.new
    respond_with @symbol_bank
  end

  # GET /symbol_banks/1/edit
  def edit
    @symbol_bank = SymbolBank.find(params[:id])
  end

  # POST /symbol_banks
  # POST /symbol_banks.json
  def create
    puts "params[:symbol_bank][:symbol_image]:::::::::::::#{params[:symbol_bank][:symbol_image].inspect}"
    puts "params[:symbol_bank]:::::::::::::#{params[:symbol_bank].inspect}"
    session[:new_symbols] = Array.new
    bank = params[:symbol_bank][:symbol_image]
    if bank
      bank.each do |sym_bank|
        @symbol_bank_new = SymbolBank.new
        puts "@symbol_bank::::::::::::#{@symbol_bank_new.inspect}"

        @symbol_bank_new.symbol_image = sym_bank
        @symbol_bank_new.symbol_name = sym_bank.original_filename[/.*(?=\..+$)/]
        puts "sym_bank.original_filename :::::::::::::::::#{sym_bank.original_filename.inspect}"
        sym_bank.original_filename = sym_bank.original_filename[0..sym_bank.original_filename.index(".")-1] + "_" + "#{Time.now.to_i}" + sym_bank.original_filename[sym_bank.original_filename.index(".")..sym_bank.original_filename.length]
        @symbol_bank_new.symbol_image_file_name = sym_bank.original_filename
        puts"image_file_name:::::::::: #{sym_bank.original_filename.inspect}"

        @symbol_bank_new.save

        @symbol_bank_new.update_attributes(:image_url => @symbol_bank_new.symbol_image.url(:medium))
        session[:new_symbols] << @symbol_bank_new.id
      end
    end
    flash[:notice] = "Symbol bank was successfully created."
    redirect_to rename_symbols_symbol_banks_path

  end

  # PUT /symbol_banks/1
  # PUT /symbol_banks/1.json
  def update
    if params[:id]
      @symbol_bank = SymbolBank.find(params[:id])

      respond_to do |format|
        if @symbol_bank.update_attributes(params[:symbol_bank])
          format.html { redirect_to @symbol_bank, notice: 'Symbol bank was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @symbol_bank.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def update_symbol_name
    puts "::::::::::::::::::UPDATE_SYMBOL_NAME:::::::::::;"
    puts "params[:symbol_bank_id]::::::::::#{params[:symbol_bank_id].inspect}"
    if params[:symbol_bank_id]
      @symbol_bank = SymbolBank.find(params[:symbol_bank_id])
      puts "@symbol_bank:::::::::::#{@symbol_bank.inspect}"
      if params[:symbol_name]
        @symbol_bank.update_attribute(:symbol_name, params[:symbol_name])
        puts "Name:::::::::::#{@symbol_bank.symbol_name.inspect}"
      end
    end
  end

  # DELETE /symbol_banks/1
  # DELETE /symbol_banks/1.json
  def destroy
    puts "I M IN DESTROY"
    puts "params[symbol_id]::::::::::::#{params[symbol_id]}"
    @symbol_bank = SymbolBank.find(params[:id])
    @symbol_bank.destroy

    respond_to do |format|
      format.html { redirect_to symbol_banks_url }
      format.json { head :no_content }
    end
  end

  def delete_symbols_from_bank
    puts "SYMBOLBANK_DELETE"
    puts "params[:symbol_bank_ids]::::::::::::::#{params[:sys_ids].inspect}"
    puts "params[symbol_id]::::::::::::#{params[:symbol_id]}"
    puts "session[:page]:::::::::::#{session[:page]}"
    if params[:symbol_id]
      puts "INSIDE params[:symbol_id]:::::::::;;;;"
      @symbol_bank_new = SymbolBank.find(params[:symbol_id].to_i)
      puts "@symbol_new::::::::::::#{@symbol_bank_new.inspect}"
      session[:new_symbols].delete(params[:symbol_id].to_i)
      @symbol_bank_new.destroy
      flash[:notice] = "Symbol successfully deleted"
      if session[:new_symbols].count > 0
        redirect_to rename_symbols_symbol_banks_path
      else
        redirect_to symbol_banks_path
      end
    else
      if params[:sys_ids]
        params[:sys_ids].each do |symbol_id|
          sym = SymbolBank.find(symbol_id.to_i)
          sym.destroy
        end
        redirect_to symbol_banks_path(:page => session[:page])
        flash[:notice] = "Symbols successfully deleted"
      else
        redirect_to symbol_banks_path(:page => session[:page])
        flash[:notice] = "No Symbols selected"
      end
    end
  end

  def cancel_symbols_saving
    ses = session[:new_symbols]
    ses.each do |symbols|
      sym = SymbolBank.find(symbols)
      sym.destroy
    end
    respond_with(@symbol_bank_new, :location => symbol_banks_path, :notice => "You have cancelled the uploaded Symbols")
  end


end
