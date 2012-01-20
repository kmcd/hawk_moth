require 'active_support/all'
require 'mongo_mapper'
MongoMapper.connection = Mongo::Connection.new 'localhost', 27017
MongoMapper.database = "hawk_moth"

module HawkMoth
end

require 'position'
require 'backtest'
require 'quote'
require 'pair'

# FIXME: this should be in the quote class or elsewhere
Quote.ensure_index [[:_id, 1], [:ticker, 1], [:timestamp, 1]], :unique => true
