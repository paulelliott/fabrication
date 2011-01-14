require 'fabrication'
load 'lib/rails/generators/fabrication/cucumber_steps/templates/fabrication_steps.rb'
load 'spec/support/active_record.rb'
load 'spec/support/helper_objects.rb'
load 'spec/support/mongoid.rb'
load 'spec/support/sequel.rb'

Before do
  TestMigration.up
  Fabrication.clear_definitions
  Fabrication::Support.find_definitions
  Fabricator(:company)
end

After do
  TestMigration.down
end
