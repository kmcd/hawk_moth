require 'statsample'

class Pair
  def initialize(ticker_1,ticker_2)
    @ticker_1, @ticker_2 = ticker_1,ticker_2
  end
  
  def cumulative_spread_zscore(time)
    return 0.0 if market_opening? time
    @quotes = intraday_quotes_upto(time)
    
    (cumulative_spreads.last - average_spread) / stdev_spread
  end
  
  def cumulative_spreads
    spreads.each_with_index.map {|spread, index| spreads[0..index].sum }
  end
  
  def spreads
    [ changes_for(@ticker_1), changes_for(@ticker_2) ].transpose.
      map {|s| s.first - s.last }
  end
  
  def quotes_and_spread_at(timestamp)
    zscore = cumulative_spread_zscore timestamp
    quotes = market_opening?(timestamp) ? intraday_quotes_upto(timestamp) : @quotes
    
    quotes[-2..-1].map {|quote| [quote.ticker.downcase.to_sym, quote.close] }.
      push zscore.round(4)
  end
  
  private
  
  def changes_for(ticker)
    ticker_quotes = @quotes.find_all {|quote| quote.ticker == ticker }
    
    ticker_quotes.each_with_index.map do |quote, index| 
      index == 0 ? 0 : ticker_quotes[index].close - ticker_quotes[index-1].close
    end
  end
  
  def average_spread
    cumulative_spreads.to_scale.mean
  end
  
  def stdev_spread
    cumulative_spreads.to_scale.standard_deviation_sample
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