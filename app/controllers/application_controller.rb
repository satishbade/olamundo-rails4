class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  def after_sign_up_path_for(resource)
    "http://www.google.com" # <- Path you want to redirect the user to after signup
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def category_sequence(from ,to)
      #@category.sequence = params[:select_sequence].to_i
      if from >  to.to_i
        Category.all.each do |e_article|
          if e_article.sequence < from  && e_article.sequence >=to.to_i
            e_article.sequence = e_article.sequence + 1

          elsif e_article.sequence == from
            e_article.sequence = to.to_i
          end
          e_article.save
        end
      else
        Category.all.each do |e_article|
          if from < e_article.sequence && e_article.sequence <= to.to_i
            e_article.sequence = e_article.sequence - 1
          elsif e_article.sequence == from
            e_article.sequence = to.to_i
          end
          e_article.save
        end
      end
  end

  def symbol_sequence(from, to)
    @cat_symbol =  Symbol1.find_all_by_category_id(session[:cat_id])
      if from > to.to_i
        @cat_symbol.each do |e_article|
          if e_article.sequence < from  && e_article.sequence >=to.to_i
            e_article.sequence = e_article.sequence + 1

          elsif e_article.sequence == from
            e_article.sequence = to.to_i
          end
          e_article.save
        end
      else
        @cat_symbol.each do |e_article|
          if from < e_article.sequence && e_article.sequence <= to.to_i
            e_article.sequence = e_article.sequence - 1
          elsif e_article.sequence == from
            e_article.sequence = to.to_i
          end
          e_article.save
        end
      end

  end

end
