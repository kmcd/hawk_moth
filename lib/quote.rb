class Quote
  include MongoMapper::Document
  plugin MongoMapper::Plugins::IdentityMap
  
  key :ticker, String
  key :timestamp, Time
  key :open, Float
  key :high, Float
  key :low, Float
  key :close, Float
  key :volume, Integer
  
  timestamps!
  
  scope :tickers, lambda {|t1,t2| 
    where '$or' => [{:ticker => t1}, {:ticker => t2}] }
  
  scope :from, lambda {|timestamp| 
    where :timestamp.gte => time_parse(timestamp) }
    
  scope :to, lambda {|timestamp| 
    where :timestamp.lte => time_parse(timestamp) }
  
  def self.time_parse(date_time)
    DateTime.parse(date_time.to_s).to_time
  end
end