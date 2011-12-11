require "rspec"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:cucumber) do |t|
    t.cucumber_opts = "--format Cucumber::Formatter::Fuubar --tags ~@wip"
  end
rescue LoadError
  puts "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
end

RSpec::Core::RakeTask.new(:turnip) do |spec|
  spec.pattern = "turnip/**/*.feature"
end

task :default => [:spec, :cucumber, :turnip]
