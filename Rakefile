# encoding: utf-8
$:.unshift(File.dirname(__FILE__) + '/lib')

require 'rubygems'
require 'rake'
require 'jeweler'
require 'zdpop/version'

version = Zdpop::Version::VERSION

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "zendesk-populator"
  gem.version = version
  gem.platform = Gem::Platform::RUBY
  gem.homepage = "http://github.com/jamtur01/zendesk-populator/"
  gem.license = "APL2"
  gem.summary = %Q{A command line tool to generate Zendesk orgs and users from CSV.}
  gem.description = %Q{A command line tool to generate Zendesk orgs and users from CSV.}
  gem.email = "james@lovedthanlost.net"
  gem.authors = ["James Turnbull"]
  gem.add_dependency "httparty"
  gem.bindir       = "bin"
  gem.executables  = %w( zdpop )
  gem.require_path = 'lib'
  gem.files = FileList['lib/**/*.rb', 'bin/*', '[A-Z]*', 'test/**/*'].to_a
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
  test.rcov_opts << '--exclude "gems/*"'
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "zendesk-populator #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
