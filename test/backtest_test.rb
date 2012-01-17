require 'helper'
    
class BacktestTest < Test::Unit::TestCase
  def setup
    @backtest = Backtest.new
  end
  
  test "should NOT generate trade history entry signal absent" do
    @backtest.spreads = oh( 
      "2011-07-08 09:30:00".dt => [ [:spy, 133.97 ], [:ivv, 134.4036], nil ],
      "2011-07-08 09:31:00".dt => [ [:spy, 134.01], [:ivv, 134.46] , nil ],
      "2011-07-08 09:32:00".dt => [ [:spy, 133.98], [:ivv, 134.451] , -0.7071 ]
    )                                                                           
                                                                    
    assert_equal "", @backtest.trades
  end                                                          
  
  test "should generate trade history when entry signal present" do
    @backtest.spreads = oh( 
      "2011-07-08 11:09:00".dt => [ [:spy, 133.57 ], [:ivv, 134.07  ],  -2.6945 ],
      "2011-07-08 11:10:00".dt => [ [:spy, 133.565], [:ivv, 134.02 ],   1.1048 ],
      "2011-07-08 11:11:00".dt => [ [:spy, 133.56],  [:ivv, 134.01  ],  1.5031 ] 
    )
    
    assert_equal "2011-07-08 11:09:00 11:11:00 long:spy short:ivv 11.03", @backtest.trades
  end
  
  test "should exit position when profit target reached" do
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