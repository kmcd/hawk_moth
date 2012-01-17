# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "hawk_moth"
  gem.homepage = "http://github.com/kmcd/hawk_moth"
  gem.license = "MIT"
  gem.summary = %Q{TODO: one-line summary of your gem}
  gem.description = %Q{TODO: longer description of your gem}
  gem.email = "keith@dancingtext.com"
  gem.authors = ["Keith Mc Donnell"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
  test.rcov_opts << '--exclude "gems/*"'
end

require 'reek/rake/task'
Reek::Rake::Task.new do |t|
  t.fail_on_error = true
  t.verbose = false
  t.source_files = 'lib/**/*.rb'
end

require 'roodi'
require 'roodi_task'
RoodiTask.new do |t|
  t.verbose = false
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "hawk_moth #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# TODO:
# - parse args more gracefully, ie without [] notation
# - patch to OS project or extract to a gem
  desc 'Create class & unit test'
  task :gen, :name do |task,args|
    class_name = args[:name].capitalize
    file_name  = args[:name].downcase
    
    write_to "lib/#{file_name}.rb", %Q{class #{class_name}\nend}
    `echo "require '#{args[:name]}'" >> lib/hawk_moth.rb`
    
    write_to "test/#{file_name}_test.rb", %Q{require 'helper'
class #{class_name}Test < Test::Unit::TestCase
  def setup
  end
  
  test "should " do
    flunk
  end
end}
  end
  
  def write_to(local_filename,text)
    File.open(local_filename, 'w') {|f| f.write(text) }
  end
 
desc "Hawk Moth irb session"
task :console do
  sh "jirb -rubygems -I lib -r hawk_moth.rb"
end
