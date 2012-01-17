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
  
  ensure_index [[:ticker, 1], [:timestamp, 1]]
  timestamps!
  
  scope :ticker, lambda {|symbol| where :ticker => symbol}
  
  scope :from, lambda {|date| 
    where :timestamp.gte => Date.parse(date.to_s).beginning_of_day }
    
  scope :to, lambda {|date| 
    where :timestamp.lte => Date.parse(date.to_s).end_of_day }
end