require 'mongo_mapper'
require 'active_support/all'
MongoMapper.connection = Mongo::Connection.new 'localhost', 27017
MongoMapper.database = "hawk_moth"

module HawkMoth
end

require 'position'
require 'backtest'
require 'quote'
