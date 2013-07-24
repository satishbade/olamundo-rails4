module CategoriesHelper
  def category
    @categories = Category.find(:all, :select => 'category_name')
    return @categories
  end
end
