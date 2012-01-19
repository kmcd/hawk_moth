#!/bin/jruby
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require "hawk_moth"

pairs = %w[ SPY IVV gld iau qqq xlk FAZ tza ].in_groups_of 2

spreads = pairs.inject(Hash.new([])).each do |spread,tickers|
  pair = Pair.new *tickers
  
  # for each bar
  #   where quotes exist for both tickers
  
  # "2011-07-08 11:09:00".dt => [[ [:spy, 133.57 ], [:ivv, 134.07 ],  -2.6945 ]],
  spread[time_stamp].merge! pair.quotes_and_spread_at(time_stamp)
end

backtest = Backtest.new
backtest.spreads = spreads
puts backtest.trades