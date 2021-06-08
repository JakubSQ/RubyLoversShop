class BrandsPresenter

  def self.list(brands)
    brands.pluck(:title)
  end

end
