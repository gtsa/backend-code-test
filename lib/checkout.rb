require_relative 'discount_database'

class Checkout
  attr_reader :prices
#  private :prices

  def initialize(prices)
    # Initializes the checkout with item prices and sets up the discount database.
    #
    # @param prices [Hash<Symbol, Numeric>] A hash mapping item symbols to their prices.
    @prices = prices
    @discount_database = DiscountDatabase.new
  end

  # Scans an item and adds it to the basket.
  #
  # @param item [Symbol] The item to scan.
  def scan(item)
    basket << item.to_sym
  end

  # Calculates the total price of items in the basket, applying any applicable discounts.
  #
  # @return [Numeric] The total price of all items in the basket.
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

  # Returns the current basket of items.
  #
  # @return [Array<Symbol>] The items currently in the basket.
  def basket
    @basket ||= []
  end

  # Counts the occurrences of each item in the basket.
  #
  # @param items [Array<Symbol>] The list of items to count.
  # @return [Hash<Symbol, Integer>] A hash mapping items to their counts.
  def items_counts(items)
    items.tally
  end
end
