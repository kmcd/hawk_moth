class Position
  FUNDS, COMMISSION_RATE = 100_000, 0.005
  
  def initialize(ticker_1, ticker_2, options)
    @ticker_1, @ticker_2, @options = ticker_1, ticker_2, options 
  end
  
  # :spy => 133.565, :ivv => 133.02
  def profit(tickers)
    net_profit = if long?
      long(tickers[@ticker_1.first]) + short(tickers[@ticker_2.first])
    else
      short(tickers[@ticker_1.first]) + long(tickers[@ticker_2.first])
    end
    net_profit - commissons
  end
  
  def long(price)
    (long_shares * price) - opening_long_portfolio
  end
  
  def short(price)
    opening_short_portfolio - (short_shares * price)
  end
  
  def long_shares
    (pair_fund / opening_long_price).round
  end
  
  def short_shares
    (pair_fund / opening_short_price).round
  end
  
  # "2011-07-08 11:09 11:11 long:spy short:ivv 11.03"
  def close(args)
    description = to_date @options[:time], "%Y-%m-%d %H:%M:%S"
    description << to_date(args.delete(:time), " %H:%M:%S")
    description << " long:#{long? ? @ticker_1.first : @ticker_2.first}"
    description << " short:#{long? ? @ticker_2.first : @ticker_1.first}"
    description << " %0.2f" % profit(args)
  end
  
  private
  
  def long?
    @options[:zscore] <= -@options[:threshold]
  end
  
  def opening_time
    DateTime.parse @options[:time]
  end
  
  def opening_long_price
    long? ? @ticker_1.last : @ticker_2.last 
  end
  
  def opening_short_price
    long? ? @ticker_2.last : @ticker_1.last
  end
  
  def opening_long_portfolio
    long_shares * opening_long_price
  end
  
  def opening_short_portfolio
    short_shares * opening_short_price
  end
  
  def commissons
    # 1 to buy and 1 to sell
    2 * (long_shares + short_shares) * COMMISSION_RATE
  end
  
  def pair_fund
    (FUNDS * 0.99) / 2
  end
  
  def to_date(object,format)
    DateTime.parse(object.to_s).strftime format
  end
end