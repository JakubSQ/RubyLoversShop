# frozen_string_literal: true

class CategoriesPresenter
  def self.list(categories)
    categories.pluck(:title)
  end
end
