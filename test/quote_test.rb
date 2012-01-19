require 'helper'
  
class QuoteTest < Test::Unit::TestCase
  def setup
  end

  test "should have a unique time and ticker" do
    quote "2011-11-14 09:30:00", "SPY", 133.97
    quote "2011-11-14 09:30:00", "SPY", 133.97
    
    assert_equal 1, Quote.count
  end
end