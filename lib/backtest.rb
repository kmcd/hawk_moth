class Backtest
  PROFIT_TARGET, ENTRY_ZSCORE = 10.0, 2.56
  attr_accessor :spreads
  
  def trades
    spreads.inject("") do |log, bar|
      if entry_signal? bar
        @position =  Position.new([:spy, 133.57], [:ivv, 134.07],
          {:zscore => zscore(bar), :threshold => ENTRY_ZSCORE, :time => bar.first})
      end
      
      if exit_signal? bar
        log << @position.close(quotes(bar))
        @position = nil
      end
      
      log
    end
  end
  
  def entry_signal?(bar)
    return if @position
    return unless zscore(bar)
    zscore(bar) <= -ENTRY_ZSCORE || zscore(bar) >= ENTRY_ZSCORE
  end
  
  def exit_signal?(bar)
    return unless @position
    @position.profit(quotes(bar)) >= PROFIT_TARGET
  end
  
  def zscore(bar)
    bar.last.last
  end
  
  def quotes(bar)
    Hash[ *bar.last[0,2].flatten ].merge!(:time => bar.first)
  end
end