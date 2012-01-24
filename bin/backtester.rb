$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require "hawk_moth"

pairs = %w[ SPY IVV gld iau qqq xlk FAZ tza ].in_groups_of 2
spreads = Hash.new {|h,k| h[k] = [] }
spy_ivv = pairs.first

# TODO: change to load spread
time_stamps = Quote.find(:tickers => spy_ivv,
  # "2012-01-09 16:00:00"
  :from => "2011-07-14 09:30:00", :to => "2011-07-14 16:00:00").
    group_by(&:time_stamp).
    delete_if {|time,bars| bars.size < 2 }.
    map(&:first).sort
  
pair = Pair.new *spy_ivv

time_stamps.each do |time_stamp|
  begin
    spreads[DateTime.parse(time_stamp)] << pair.quotes_and_spread_at(time_stamp)
  rescue
    pp pair, time_stamp
  end
end

backtest = Backtest.new
backtest.spreads = spreads
puts backtest.trades