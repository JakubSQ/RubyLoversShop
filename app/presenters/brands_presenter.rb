# frozen_string_literal: true

class BrandsPresenter
  def self.list(brands)
    brands.pluck(:title)
  end
end
