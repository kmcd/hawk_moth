require 'redis'

class Quote
  attr_reader :time_stamp, :ticker, :close
  
  def initialize(json_hash)
    quote = JSON.parse(json_hash).symbolize_keys!
    @time_stamp, @ticker, @close = quote[:time_stamp], quote[:ticker], 
      quote[:close].to_f
  end
  
  def self.create(time_stamp, ticker, close)
    ts = DateTime.parse(time_stamp)
    quote = { :time_stamp => ts.to_s(:db), :close => close, :ticker => ticker }.
      to_json
    repository.zadd ticker, ts.to_i, quote
  end
  
  def self.count(ticker)
    repository.zcard ticker
  end
  
  # :tickers => %[ SPY IVV ], :from => date_time, :to => date_time
  # => [ Quote.new, ... ]
  def self.find(args)
    from, to = args[:from], args[:to]
    
    args[:tickers].map do |ticker|
      repository.zrangebyscore(ticker, dt(from).to_i, dt(to).to_i).
        map {|json| Quote.new json }
    end.flatten.sort_by &:time_stamp
  end
  
  private
  
  def self.repository
    Redis.current
  end
  
  def self.dt(date_time)
    DateTime.parse date_time.to_s
  end
end