#!/bin/jruby
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require "hawk_moth"
require "fastercsv"

Dir["./data/*.csv"].each do |quotes|
  FasterCSV.foreach(quotes, :headers => true) do |quote|
    Quote.create :ticker => quote[0], 
      :timestamp => "#{quote[1]} #{quote[2]}", 
      :open => quote[3],
      :high => quote[4],
      :low =>  quote[5],
      :close => quote[6],
      :volume => quote[7]
  end
end
