class Position
  FUNDS, COMMISSION_RATE = 100_000, 0.005
  
  def initialize(options)
    @opening_short_price, @opening_long_price = options[:short], options[:long]
  end
  
  def value(options={:long => @opening_long_price, :short => @opening_short_price})
    (long(options[:long]) + short(options[:short])) - commissons
  end
  
  def long(price=@opening_long_price)
    opening_price = long_shares * @opening_long_price
    current_price = long_shares * price
    current_price - opening_price
  end
  
  def short(price=@opening_short_price)
    opening_price = short_shares * @opening_short_price
    current_price = short_shares * price
    opening_price - current_price
  end
  
  def commissons
    # 1 to buy and 1 to sell
    2 * (long_shares + short_shares) * COMMISSION_RATE
  end
  
  def long_shares
    (pair_fund / @opening_long_price).round
  end
  
  def short_shares
    (pair_fund / @opening_short_price).round
  end
  
  def pair_fund
    (FUNDS * 0.99) / 2
  end
end