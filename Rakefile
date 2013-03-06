require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:cucumber) do |t|
  t.cucumber_opts = "--format progress --tags ~@wip"
end

task :default => [:spec, :cucumber]
