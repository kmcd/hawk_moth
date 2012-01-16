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
require 'active_support'
require 'active_support/testing/declarative'
require 'ruby-debug'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hawk_moth'

include ActiveSupport

class Test::Unit::TestCase
  extend ActiveSupport::Testing::Declarative
end

class String
  def dt
    DateTime.parse self
  end
end

def oh(*args)
  hash = OrderedHash.new
  args.each {|arg| hash.merge! arg }
  hash
end
