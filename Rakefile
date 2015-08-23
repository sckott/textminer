require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

desc "Run tests"
task :default => :test

desc "Build textminer"
task :build do
	system "gem build textminer.gemspec"
end

desc "Install textminer"
task :install => :build do
	system "gem install textminer-#{Textminer::VERSION}.gem"
end

desc "Release to Rubygems"
task :release => :build do
  system "gem push textminer-#{Textminer::VERSION}.gem"
end
