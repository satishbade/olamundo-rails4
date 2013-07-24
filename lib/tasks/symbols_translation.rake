namespace :english_to_hebrew do
  task :translate => :environment do
    require 'json'
    require 'open-uri'

    symbol_words = Symbol1.all
    symbol_words.each do |symbol|
      puts "WORD :::: #{symbol.word}"
      if symbol.hebrew == nil
        sym_word = URI.escape(symbol.word.to_s)
        uri = URI.parse("https://www.googleapis.com/language/translate/v2?key=AIzaSyCBbvppipGCRgKlhYvaHgFjk7uU1nMuMLc&q=#{sym_word}&source=en&target=iw")
        str = uri.read
        json_data = JSON.parse(str)
        hebrew_word = json_data["data"]["translations"].first["translatedText"]
        puts "json_data:::::#{hebrew_word}"
        symbol.update_attribute(:hebrew, hebrew_word)
      end
    end

    categories = Category.all
    categories.each do |category|
      puts "NAME :::: #{category.category_name}"
      if category.hebrew == nil
        cat_name = URI.escape(category.category_name.to_s)
        uri = URI.parse("https://www.googleapis.com/language/translate/v2?key=AIzaSyCBbvppipGCRgKlhYvaHgFjk7uU1nMuMLc&q=#{cat_name}&source=en&target=iw")
        str = uri.read
        json_data = JSON.parse(str)
        hebrew_word = json_data["data"]["translations"].first["translatedText"]
        puts "json_data:::::#{hebrew_word}"
        category.update_attribute(:hebrew, hebrew_word)
      end
    end

    related_symbol = Relatedsymbol.all
    related_symbol.each do |related_sym|
      puts "NAME :::: #{related_sym.symbol_text}"
      if related_sym.hebrew == nil
        rel_sym = URI.escape(related_sym.symbol_text.to_s)
        uri = URI.parse("https://www.googleapis.com/language/translate/v2?key=AIzaSyCBbvppipGCRgKlhYvaHgFjk7uU1nMuMLc&q=#{rel_sym}&source=en&target=iw")
        str = uri.read
        json_data = JSON.parse(str)
        hebrew_word = json_data["data"]["translations"].first["translatedText"]
        puts "json_data:::::#{hebrew_word}"
        related_sym.update_attribute(:hebrew, hebrew_word)
      end
    end

  end
end