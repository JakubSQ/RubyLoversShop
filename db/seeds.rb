# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

User.create(email: 'user@example', password: 'password')
Admin.create(email: 'admin@example', password: 'password')

3.times do
  category = Category.create(title: Faker::Commerce.department(max: 1, fixed_amount: true))
  brand = Brand.create(title: Faker::Appliance.brand)
end

10.times do
  product = Product.create(name: Faker::Commerce.unique.product_name,
                           prize: Faker::Number.non_zero_digit,
                           description: Faker::Lorem.sentence,
                           brand: Brand.all.sample,
                           category: Category.all.sample)
end
