require 'helper'
  
class QuoteTest < Test::Unit::TestCase
  test "should have a unique time and ticker" do
    Quote.create "2011-11-14 09:30:00", "SPY", 133.97
    Quote.create "2011-11-14 09:30:00", "SPY", 133.97

    assert_equal 1, Quote.count("SPY")
  end
  
  test "should fetch quotes by date range for ticker pair" do
    fixtures = [["2011-11-14 09:30:00", "SPY", 133.97 ],
      ["2011-11-14 09:30:00", "IVV", 134.4036],
      ["2011-11-14 09:31:00", "SPY", 134.01],
      ["2011-11-14 09:31:00", "IVV", 134.46]]
      
    fixtures.each {|fixture| Quote.create *fixture }
    
    quotes = Quote.find :tickers => %w[ SPY IVV ], 
      :from => "2011-11-14 09:30:00", :to => "2011-11-14 09:31:00"
             
    assert_equal fixtures, quotes.map {|quote| [ quote.time_stamp, quote.ticker,
      quote.close ] }
  end
end