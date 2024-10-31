class DiscountDatabase
  def initialize
    @discounts = {
      apple: { type: :buy_one_get_one_free },
      pear: { type: :buy_one_get_one_free },
      banana: { type: :half_price },
      pineapple: { type: :first_item_half_price },
      mango: { type: :buy_three_get_one_free }
    }
  end

  def get_discount_type(item)
    discount = @discounts[item]
    discount ? discount[:type] : :discount_nan
  end

  def calculate_price(price, count, discount_type)
    case discount_type
    when :buy_one_get_one_free
      price * (count - count/2)
    when :buy_three_get_one_free
      price * (count - count/4)
    when :first_item_half_price
      price / 2 + price * (count - 1)
    when :half_price
      (price / 2) * count
    else
      price * count
    end
  end
end

class Checkout
  attr_reader :prices
  private :prices

  def initialize(prices)
    @prices = prices
    @discount_database = DiscountDatabase.new
  end

  def scan(item)
    basket << item.to_sym
  end

  def total
    total = 0

    items_counts(basket).each do |item, count|
      discount_type = @discount_database.get_discount_type(item)
      price = prices.fetch(item)
      total += @discount_database.calculate_price(price, count, discount_type)
    end

    total
  end

  private

  def basket
    @basket ||= Array.new
  end

  def items_counts(items)
    items.tally
  end
end
