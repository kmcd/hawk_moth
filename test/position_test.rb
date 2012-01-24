require 'helper'
  
class PositionTest < Test::Unit::TestCase
  def setup
    @position = Position.new([:spy, 133.57], [:ivv, 134.07],
      {:score => -0.0319, :threshold => 0.03, :time => "2011-07-08 11:09:00"})
  end
  
  # @position.profit :spy => 133.57, :ivv => 134.07,
  test "should calculate current profit" do
    assert_in_delta -7.39, @position.profit(:spy => 133.57, :ivv => 134.07), 0.1
    assert_in_delta 9.19, @position.profit(:spy => 133.565, :ivv => 134.02), 0.1
    assert_in_delta 11.03, @position.profit(:spy => 133.56, :ivv => 134.01), 0.1
  end
  
  test "should be dollar neutral" do
    assert (@position.long(133.57) - @position.short(134.07)) < 133.57
    assert (@position.long(133.57) - @position.short(134.07)) < 134.07
  end
  
  test "should NEVER exceeed total funds" do
    assert(@position.profit(:spy => 133.57, :ivv => 134.07) < Position::FUNDS)
  end
  
  test "should NOT have fractional shares" do
    assert_equal 0, @position.long_shares % 1
    assert_equal 0, @position.short_shares % 1
  end
  
  # @position.close :spy => 133.57, :ivv => 134.07, :time => from_bar
  # => "2011-07-08 11:09 11:11 long:spy short:ivv 11.03"
  test "should have a profit and loss statement" do
    assert_equal "2011-07-08 11:09:00 11:11:00 long:spy short:ivv 11.05", 
      @position.close(:spy => 133.57, :ivv => 134.02, :time => "11:11:00")
  end
end