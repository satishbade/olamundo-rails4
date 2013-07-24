namespace :symbol_bank do
  task :add_symbols => :environment do


    puts "Total symbols - #{Symbol1.count}"
    #puts "Total unique symbols - #{Symbol1.select("DISTINCT symbol_image_file_name").count}"
    #puts "Total duplicate symbols - #{Symbol1.select("symbol_image_file_name").group(:symbol_image_file_name).having("count(symbol_image_file_name) > 1").length}"

    symbols = Symbol1.all
    puts "uniq_symbols::::::::::::::#{symbols.inspect}"
    symbols.each do |symbol|
      symbol_bank = SymbolBank.new
      symbol_bank.symbol_image_file_name = symbol.symbol_image_file_name
      symbol_bank.image_url = symbol.image_url
      symbol_bank.symbol_name = symbol.word
      symbol_bank.save
    end

    #categories = Category.all
    #puts "categroy:::::::::::::::#{categories.inspect}"
    #categories.each do |cat|
    #  puts "cat::::::::::::#{cat.inspect}"
    #  user_cat = UserCategory.new
    #  user_cat.category_name = cat.category_name
    #  user_cat.
    #  user_cat.save
    #end
    #
    #related_symbols = Relatedsymbol.all
    #puts "categroy:::::::::::::::#{related_symbols.inspect}"
    #related_symbols.each do |rel|
    #  puts "rel::::::::::::#{rel.inspect}"
    #  user_cat = UserCategoryRelatedSymbol.new
    #  user_cat = rel
    #  user_cat.save
    #end





  end
end

