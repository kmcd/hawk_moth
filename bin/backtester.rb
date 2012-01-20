$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require "hawk_moth"

pairs = %w[ SPY IVV gld iau qqq xlk FAZ tza ].in_groups_of 2
spreads = Hash.new([])

pairs.each do |tickers|
  pair = Pair.new *tickers
  
  pp pair
  
  time_stamps = Quote.tickers(*tickers).
    to(DateTime.now).
    all.
    group_by(&:timestamp).
    delete_if {|time,bars| bars.size < 2 }.
    map(&:first).sort
  
  pp time_stamps
  
  time_stamps.each do |time_stamp|
    # "2011-07-08 11:09:00".dt => [[ [:spy, 133.57 ], [:ivv, 134.07 ],  -2.6945 ]],
    pp pair.quotes_and_spread_at(time_stamp)
    spreads[time_stamp] << pair.quotes_and_spread_at(time_stamp)
  end
  
  pp spreads
end

# pp spreads.
# backtest = Backtest.new
# backtest.spreads = spreads
# puts backtest.trades