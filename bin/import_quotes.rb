#!/bin/jruby
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require "hawk_moth"
require "fastercsv"

Dir["./data/*.csv"].each do |quotes|
  FasterCSV.foreach(quotes, :headers => true) do |quote|
    Quote.create "#{quote['Date']} #{quote['Time']}", quote['Ticker'], quote['Close']
  end
end
