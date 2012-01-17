#!/bin/jruby
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require "hawk_moth"

backtest = Backtest.new

# for each pair
#   for each bar
#     create spread

# pass spreads to backtest in correct format:
# "2011-07-08 11:09:00".dt => [[ [:spy, 133.57 ], [:ivv, 134.07  ],  -2.6945 ]],
# "2011-07-08 11:10:00".dt => [[ [:spy, 133.565], [:ivv, 134.02 ],   1.1048 ]],
# "2011-07-08 11:11:00".dt => [[ [:spy, 133.56],  [:ivv, 134.01  ],  1.5031 ]]

# backtest.spreads = 

puts backtest.trades