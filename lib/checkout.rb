class DiscountDatabase
  DISCOUNT_TYPES = {
    buy_one_get_one_free: { formula: 'price * (count - count / 2)' },
    buy_three_get_one_free: { formula: 'price * (count - count / 4)' },
    first_item_half_price: { formula: 'price / 2 + price * (count - 1)' },
    half_price: { formula: '(price / 2) * count' },
    no_discount: { formula: 'price * count' }
  }

  def initialize
    @discounts = {
      apple: :buy_one_get_one_free,
      pear: :buy_one_get_one_free,
      banana: :half_price,
      pineapple: :first_item_half_price,
      mango: :buy_three_get_one_free
    }
  end

  def get_discount_type(item)
    @discounts.fetch(item, :no_discount)
  end

  def calculate_price(price, count, discount_type)
    formula_str = DISCOUNT_TYPES.fetch(discount_type)[:formula]
    eval(formula_str)
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
    @basket ||= []
  end

  def items_counts(items)
    items.tally
  end
end
