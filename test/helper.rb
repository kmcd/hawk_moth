require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'turn'
require 'ruby-debug'
require 'active_support/testing/declarative'
require 'fastercsv'
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hawk_moth'

Quote.repository.select "hawk_moth_test"

class Test::Unit::TestCase
  extend ActiveSupport::Testing::Declarative
  
  def teardown
    Quote.repository.flushdb
  end
  
  # Ensure each test case has a teardown method to clear the db after each test
  def inherited(base)
    base.define_method(teardown) { super }
  end
end

class String
  def dt
    DateTime.parse self
  end
end

def oh(*args)
  hash = ActiveSupport::OrderedHash.new
  args.each {|arg| hash.merge! arg }
  hash
end

def quote(time, ticker, close)
  Quote.create time, ticker, close
end

def load_fixtures
  FasterCSV.foreach('./test/fixtures.csv') do |row|
    timestamp = row.first
    quote timestamp, "SPY", row[-2]
    quote timestamp, "IVV", row[-1]
  end
end
