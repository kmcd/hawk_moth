$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require "hawk_moth"

pairs = %w[ SPY IVV gld iau qqq xlk FAZ tza ].in_groups_of 2
spreads = Hash.new {|h,k| h[k] = [] }

current_pair = %w[ SPY IVV ]

time_stamps = Quote.find(:tickers => current_pair,
  :from => "2011-06-15 09:30:00", :to => "2012-01-09 16:00:00").
    group_by(&:time_stamp).
    delete_if {|time,bars| bars.size < 2 }.
    map(&:first).sort.
    map {|ts| DateTime.parse(ts) }
  
pair = Pair.new *current_pair

time_stamps.each do |time_stamp|
  begin
    spreads[time_stamp] << pair.quotes_and_spread_at(time_stamp)
  rescue
    pp pair, time_stamp
  end
end

backtest = Backtest.new
backtest.spreads = spreads
trades_report = "./data/#{current_pair.join('_')}_trades.txt"

File.open(trades_report, 'w') {|f| f.write backtest.trades }