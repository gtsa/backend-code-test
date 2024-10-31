class Checkout
  attr_reader :prices
  private :prices

  def initialize(prices)
    @prices = prices
  end

  def scan(item)
    basket << item.to_sym
  end

  def total
    total = 0

    items_counts(basket).each do |item, count|
      case item
      when :apple, :pear
        total += discount_buy_one_get_one_free(prices.fetch(item), count)
      when :pineapple
        total += discount_first_item_half_price(prices.fetch(item), count)
      when :mango
        total += discount_buy_three_get_one_free(prices.fetch(item), count)
      when :banana
        total += discount_half_price(prices.fetch(item), count)
      else
        total += discount_nan(prices.fetch(item), count)
      end
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

  def discount_buy_one_get_one_free(price, count)
    price * (count - count/2)
  end

  def discount_buy_three_get_one_free(price, count)
    price * (count - count/4)
  end

  def discount_first_item_half_price(price, count)
    price / 2 + price * (count - 1)
  end

  def discount_half_price(price, count)
    (price / 2) * count
  end

  def discount_nan(price, count)
    price * count
  end
end
