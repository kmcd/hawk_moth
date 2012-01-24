require 'helper'

class PairTest < Test::Unit::TestCase
  def setup
    @pair = Pair.new 'SPY', 'IVV'
  end
  
  test "should have spread of zero on market open" do
    quote "2011-07-08 09:30:00", "SPY", 133.97
    quote "2011-07-08 09:30:00", "IVV", 134.4036
    
    assert_equal 0.0, @pair.spread_at("2011-07-08 09:30:00")
  end
  
  test "should calculate difference between current spread and moving average" do
    quote "2011-07-08 09:30:00", "SPY", 133.97
    quote "2011-07-08 09:30:00", "IVV", 134.4036
    quote "2011-07-08 09:31:00", "SPY", 134.01	
    quote "2011-07-08 09:31:00", "IVV", 134.46
    
    assert_in_delta -0.0082, @pair.spread_at("2011-07-08 09:31:00"), 0.0001
  end
  
  test "should calculate moving average from market open" do
    quote "2011-07-08 09:30:00", "SPY", 133.97
    quote "2011-07-08 09:30:00", "IVV", 134.4036
    quote "2011-07-08 09:31:00", "SPY", 134.01	
    quote "2011-07-08 09:31:00", "IVV", 134.46
    quote "2011-07-08 09:32:00", "SPY", 133.98
    quote "2011-07-08 09:32:00", "IVV", 134.451
    
    assert_in_delta -0.0195, @pair.spread_at("2011-07-08 09:32:00"), 0.0001
  end
  
  test "should only use current day for spread calculations" do
    quote "2011-07-08 16:00:00", "SPY", 133.97
    quote "2011-07-08 16:00:00", "IVV", 134.4036
    quote "2011-11-15 09:30:00", "SPY", 134.01	
    quote "2011-11-15 09:30:00", "IVV", 134.46
    
    assert_equal 0.0, @pair.spread_at("2011-11-15 09:30:00")
  end
  
  test "should ignore missing bars" do
    quote "2011-07-08 09:30:00", "SPY", 133.97
    quote "2011-07-08 09:30:00", "IVV", 134.4036
    quote "2011-07-08 09:31:00", "SPY", 134.01
    quote "2011-07-08 09:32:00", "SPY", 134.01	
    quote "2011-07-08 09:32:00", "IVV", 134.46
    
    assert_in_delta -0.0082, @pair.spread_at("2011-07-08 09:32:00"), 0.0001
  end
  
  test "should detect a high/low spread" do
    load_fixtures
    
    assert_in_delta -0.0319, @pair.spread_at("2011-07-08 10:59:00"), 0.0001
    assert_in_delta -0.0319, @pair.spread_at("2011-07-08 11:09:00"), 0.0001
    assert_in_delta 0.0359, @pair.spread_at("2011-07-08 11:40:00"), 0.0001
  end
  
  test "should have quotes and spread for a timestamp" do
    quote "2011-07-08 09:30:00", "SPY", 133.97
    quote "2011-07-08 09:30:00", "IVV", 134.4036
    assert_equal [[:spy, 133.97], [:ivv, 134.4036],  0.0], @pair.quotes_and_spread_at("2011-07-08 09:30:00")
    
    quote "2011-07-08 09:31:00", "SPY", 134.01	
    quote "2011-07-08 09:31:00", "IVV", 134.46
    assert_equal [[:spy, 134.01], [:ivv, 134.46],  -0.0082], @pair.quotes_and_spread_at("2011-07-08 09:31:00")
  end
end