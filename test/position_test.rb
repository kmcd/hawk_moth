require 'helper'
  
class PositionTest < Test::Unit::TestCase
  def setup
    @position = Position.new({:long => 133.76, :short => 134.26})
  end
  
  test "should calculate current value" do
    assert_in_delta -7.39, @position.value, 0.001
    assert_in_delta -7.39, @position.value(:long => 133.76, :short => 134.26), 0.001
    assert_in_delta 10.87, @position.value(:long => 133.57, :short => 134.02), 0.001
  end
  
  test "should be dollar neutral" do
    assert(@position.long - @position.short < 133.76)
    assert(@position.long - @position.short < 134.26)
  end
  
  test "should NEVER exceeed total funds" do
    assert(@position.value < Position::FUNDS)
  end
  
  test "should NOT have fractional shares" do
    assert_equal 0, @position.long_shares % 1
    assert_equal 0, @position.short_shares % 1
  end
end