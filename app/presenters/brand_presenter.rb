# frozen_string_literal: true

class BrandPresenter
  def self.list
    Brand.pluck(:title)
  end
end
