# frozen_string_literal: true

class CategoryPresenter
  def self.list
    Category.pluck(:title)
  end
end
