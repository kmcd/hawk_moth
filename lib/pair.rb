require 'statsample'

class Pair
  def initialize(ticker_1,ticker_2)
    @ticker_1, @ticker_2 = ticker_1,ticker_2
  end
  
  def spread_zscore(time_stamp)
    return 0.0 if market_opening? time_stamp
    @quotes = intraday_quotes_upto(time_stamp)
    dist  = spreads.to_scale
    
    (spreads.last - dist.mean) / dist.standard_deviation_sample
  end
  
  def quotes_and_spread_at(time_stamp)
    zscore = spread_zscore time_stamp
    quotes = market_opening?(time_stamp) ? intraday_quotes_upto(time_stamp) : @quotes
    
    quotes[-2..-1].map {|quote| [quote.ticker.downcase.to_sym, quote.close] }.
      push zscore.round(4)
  end
  
  private
  
  def spreads
    @quotes.in_groups_of(2).map {|s| s.first.close - s.last.close }.flatten
  end
  
  def intraday_quotes_upto(current_time)
    Quote.find(:tickers => [@ticker_1, @ticker_2],
      :from => market_open(current_time),
      :to => current_time).
        group_by(&:time_stamp).
        delete_if {|time,bars| bars.size < 2 }.
        map(&:last).
        flatten.
        sort_by &:time_stamp
  end
  
  def market_opening?(time)
    DateTime.parse(time.to_s) == market_open(time)
  end
  
  def market_open(time)
    DateTime.parse(time.to_s).change :hour => 9, :min => 30
  end
end