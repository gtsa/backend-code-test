class DiscountDatabase
  # Mapping of discount types to their respective calculation formulas.
  DISCOUNT_TYPES = {
    buy_one_get_one_free: { formula: 'price * (count - count / 2)' },
    buy_three_get_one_free: { formula: 'price * (count - count / 4)' },
    first_item_half_price: { formula: 'price / 2 + price * (count - 1)' },
    half_price: { formula: '(price / 2) * count' },
    no_discount: { formula: 'price * count' }
  }

  def initialize
    # Initializes the discounts for different items
    @discounts = {
      apple: :buy_one_get_one_free,
      pear: :buy_one_get_one_free,
      banana: :half_price,
      pineapple: :first_item_half_price,
      mango: :buy_three_get_one_free
    }
  end

  # Gets the discount type for a given item.
  #
  # @param item [Symbol] The item to look up.
  # @return [Symbol] The discount type associated with the item, or :no_discount if not found.
  def get_discount_type(item)
    @discounts.fetch(item, :no_discount)
  end

  # Calculates the price based on the discount type.
  #
  # @param price [Numeric] The price of a single item.
  # @param count [Integer] The number of items.
  # @param discount_type [Symbol] The discount type to apply.
  # @return [Numeric] The total price after applying the discount.
  def calculate_price(price, count, discount_type)
    formula_str = DISCOUNT_TYPES.fetch(discount_type)[:formula]
    eval(formula_str) # Evaluates the string formula.
  end
end
