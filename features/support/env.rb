require 'fabrication'
load 'lib/rails/generators/fabrication/cucumber_steps/templates/fabrication_steps.rb'
load 'spec/support/active_record.rb'
load 'spec/support/plain_old_ruby_objects.rb'
load 'spec/support/mongoid.rb'
load 'spec/support/sequel.rb'

Before do
  clear_mongodb
  TestMigration.up
  Fabrication.clear_definitions
  Fabrication::Support.find_definitions
end

After do
  TestMigration.down
end
