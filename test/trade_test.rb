require 'helper'

def spread(datetime, *values)
  OrderedHash.new(DateTime.parse(datetime) => {:spy_ivv => values })
end

class TradeTest < Test::Unit::TestCase
  def setup
    @trade = Trade.new :fund => 100_000, :entry_z => 2.56, :exit_pt => 10
  end
  
  test "should NOT generate trade history entry signal absent" do
    @trade.spreads = OrderedHash.new
    assert_nil @trade.history
    
    @trade.spreads = spread "2011-07-08	09:30:00	", 133.97,	 134.4036, nil
    assert_nil @trade.history
    
    @trade.spreads = spread "2011-07-08	09:31:00	", 134.01,	 134.46, nil
    assert_nil @trade.history
    
    @trade.spreads = spread "2011-07-08	09:32:00	", 133.98,	 134.451, -0.7071
    assert_nil @trade.history
  end
  
  test "should generate trade history when entry signal present" do
    @trade.spreads =      
      spread("2011-07-08 11:09:00", 133.57, 134.07, -2.6945).merge(
      spread("2011-07-08 11:10:00", 133.565, 134.02, 1.1048)).merge(
      spread("2011-07-08 11:11:00", 133.56, 134.01, 1.5031))
                                                         
    assert_equal "2011-07-08 11:09 11:11 long:spy short:ivv 11.03", @trade.history
  end
                
  test "should have position entry & exit time" do
    flunk
  end 
   
  test "should exit position when profit target attained" do
    flunk
  end
  
  test "should create a short entry position when spread is high" do
    flunk
  end
  
  test "should create a long entry position when spread is low" do
    flunk
  end
  
  test "should not hold overnight positions" do
    flunk
  end
  
  test "should select greatest entry signal when multiple signals present" do
    flunk
  end
  
  test "should only hold one position at a time" do
    flunk
  end
end