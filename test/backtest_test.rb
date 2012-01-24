require 'helper'
    
class BacktestTest < Test::Unit::TestCase
  def setup
    @backtest = Backtest.new
  end
  
  test "should NOT generate trade history entry signal absent" do
    @backtest.spreads = oh( 
      "2011-07-08 09:30:00".dt => [[ [:spy, 133.97 ], [:ivv, 134.4036], 0.0 ]],
      "2011-07-08 09:31:00".dt => [[ [:spy, 134.01], [:ivv, 134.46] , -0.082 ]],
      "2011-07-08 09:32:00".dt => [[ [:spy, 133.98], [:ivv, 134.451] , -0.0195 ]]
    )

    assert_equal "", @backtest.trades
  end                                                          
  
  test "should generate trade history when entry signal present" do
    @backtest.spreads = oh( 
      "2011-07-08 11:09:00".dt => [[ [:spy, 133.57 ], [:ivv, 134.07  ],  -0.0318 ]],
      "2011-07-08 11:10:00".dt => [[ [:spy, 133.565], [:ivv, 134.02 ],   0.0131 ]],
      "2011-07-08 11:11:00".dt => [[ [:spy, 133.56],  [:ivv, 134.01  ],  0.0179 ]] 
    )
    
    assert_equal "2011-07-08 11:09:00 11:11:00 long:spy short:ivv 11.03\n", @backtest.trades
  end
                                
  test "should create a short entry position when spread is high" do
    @backtest.spreads = oh( 
      "2011-07-08	11:40:00".dt => [[ [:spy, 133.82], [:ivv, 134.25 ], 0.0359]],
      "2011-07-08	11:41:00".dt => [[ [:spy, 133.81], [:ivv, 134.268], 0.0079]], 
      "2011-07-08	11:42:00".dt => [[ [:spy, 133.78], [:ivv, 134.24 ], 0.0058]],
      "2011-07-08	11:43:00".dt => [[ [:spy, 133.78], [:ivv, 134.26 ], 0.0359]]
    )                                                 
    
    assert_equal "2011-07-08 11:40:00 11:43:00 long:ivv short:spy 11.10\n", @backtest.trades
  end
  
  test "should NOT enter on market close" do
    @backtest.spreads = oh( 
      "2011-07-08	16:00:00".dt => [[ [:spy, 134.58], [:ivv, 134.98 ], 0.460 ]])
    
    assert_equal "", @backtest.trades
  end
  
  test "should not hold overnight positions" do
    @backtest.spreads = oh( 
      "2011-07-08 15:59:00".dt => [[ [:spy, 134.01 ], [:ivv, 134.5124  ],  -0.0366 ]],
      "2011-07-08 16:00:00".dt => [[ [:spy, 133.9711], [:ivv, 134.44 ],   -0.0031 ]] )
                                          
    assert_equal "2011-07-08 15:59:00 16:00:00 long:spy short:ivv 4.92\n", @backtest.trades
  end
  
  test "should select greatest entry signal when multiple signals present" do
    @backtest.spreads = oh( 
      "2011-07-08 11:09:00".dt => [
        [[:gld, 133.57 ], [:iau, 134.07  ],  -0.0318 ],
        [[:spy, 133.57 ], [:ivv, 134.07  ],  -0.0317 ]
      ],
      "2011-07-08 11:11:00".dt => [
        [[:gld, 133.56],  [:iau, 134.01  ],  0.0179 ],
        [[:spy, 133.56],  [:ivv, 134.01  ],  0.0178 ]
      ])
    
    assert_equal "2011-07-08 11:09:00 11:11:00 long:gld short:iau 11.03\n", @backtest.trades
  end
end