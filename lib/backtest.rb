# TODO: create Bar class for entry/exit, spread, long/short

class Backtest
  PROFIT_TARGET, ENTRY_ZSCORE = 10.0, 2.56
  attr_accessor :spreads
  
  def trades
    spreads.inject("") do |log, bar|
      if entry_signal? bar
        entry = Hash[ *bar.last.find(&bar_entry_signal) ]
        zscore = entry.values.first.flatten.last
        
        # TODO: move to Position factory
          spread_high?(zscore) ? short(entry) : long(entry)
      end
      
      if exit_signal? bar
        quotes = Hash[*bar].values.first.values.flatten
        log << @position.log(:long => quotes[1], :short => quotes[0])
        @position = nil
      end
      
      log
    end
  end
  
  def entry_signal?(bar)
    return if @position
    bar.last.any? &bar_entry_signal
  end
  
  def exit_signal?(bar)
    return unless @position
    quotes = Hash[*bar].values.first.values.flatten
    @position.value(:long => quotes[0], :short => quotes[1]) >= PROFIT_TARGET
  end
  
    def spread_high?(zscore)
      pp zscore, ENTRY_ZSCORE, zscore >= ENTRY_ZSCORE
      zscore >= ENTRY_ZSCORE
    end
    
    def short(bar)
      # TODO: create a Position factory
      pair =  bar.keys.first
      quotes = bar.values.flatten
      @position = Position.new :tickers => pair, :long => quotes[1], :short => quotes[0]
    end
    
    def long(bar)
      pair =  bar.keys.first
      quotes = bar.values.flatten
      @position = Position.new :tickers => pair, :long => quotes[0], :short => quotes[1]
    end
  
  def bar_entry_signal
    lambda do |bar,quotes|
      next unless quotes.last
      zscore = quotes.last
      zscore <= -ENTRY_ZSCORE || zscore >= ENTRY_ZSCORE
    end
  end
end