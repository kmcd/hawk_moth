class Backtest
  PROFIT_TARGET, ENTRY_ZSCORE = 10.0, 2.56
  attr_accessor :spreads
  
  def trades
    spreads.inject("") do |log, bars|
      bar = top_signal_from bars
      
      if entry_signal? bar
        @position =  Position.new bar.last[0], bar.last[1],
          {:zscore => zscore(bar), :threshold => ENTRY_ZSCORE, :time => bar.first}
      end
      
      if exit_signal? bar
        log << @position.close(quotes(bar))
        @position = nil
      end
      
      log
    end
  end
  
  private
  
  # TODO: move to Bar
  def entry_signal?(bar)
    return if @position
    return unless zscore(bar)
    return if end_of_day?(bar)
    zscore(bar) <= -ENTRY_ZSCORE || zscore(bar) >= ENTRY_ZSCORE
  end
  
  def exit_signal?(bar)
    return unless @position
    return true if end_of_day?(bar)
    @position.profit(quotes(bar)) >= PROFIT_TARGET
  end
  
  def zscore(bar)
    bar.last.last
  end
  
  def quotes(bar)
    Hash[ *bar.last[0,2].flatten ].merge!(:time => bar.first)
  end
  
  def end_of_day?(bar)
    bar.first.strftime("%H:%M") == "16:00"
  end
  
  def top_signal_from(bars)
    timestamp, quotes = bars.first, bars.last
    top_signal = quotes.map {|bar| (bar.last || 0).abs }.max
    quotes_and_spread = quotes.find {|bar| (bar.last || 0).abs >= top_signal }
    
    [timestamp, quotes_and_spread]
  end
end