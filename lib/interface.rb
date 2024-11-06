require_relative 'checkout'
require_relative 'discount_database'

p DiscountDatabase::DISCOUNT_TYPES

prices = { apple: 1.00, pear: 1.50, banana: 0.75, pineapple: 2.00, mango: 1.25 }
checkout = Checkout.new(prices)
p checkout.prices
puts "Total: #{checkout.total}"
