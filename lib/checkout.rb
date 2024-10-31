class Checkout
  attr_reader :prices
  private :prices

  def initialize(prices)
    @prices = prices
  end

  def scan(item)
    basket << item.to_sym
  end

  def items_counts(items)
    items.tally
  end

  def total
    total = 0

    items_counts(basket).each do |item, count|
      if item == :apple || item == :pear
        total += discount_buy_one_get_one_free(prices.fetch(item), count)
      elsif item == :banana || item == :pineapple || item == :mango
        if item == :pineapple
          total += discount_first_item_half_price(prices.fetch(item), count)
        elsif item == :mango
          total += discount_buy_three_get_one_free(prices.fetch(item), count)
        else
          total += discount_half_price(prices.fetch(item), count)
        end
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

  def discount_buy_one_get_one_free(price, count)
    if (count % 2 == 0)
      price * (count / 2)
    else
      price * count
    end
  end

  def discount_buy_three_get_one_free(price, count)
    price * (count - count/4)
  end

  def discount_first_item_half_price(price, count)
    total = price / 2
    total += price * (count - 1)
  end

  def discount_half_price(price, count)
    (price / 2) * count
  end

  def discount_nan(price, count)
    price * count
  end
end
