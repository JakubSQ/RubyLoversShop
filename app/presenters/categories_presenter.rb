class CategoriesPresenter

  def self.list(categories)
    categories.pluck(:title)
  end

end
