require 'bundler'

Bundler.require(:default, :development)

Dir[File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec', 'support', '**', '*.rb'))].sort.each do |f|
  require f
end
load 'lib/rails/generators/fabrication/cucumber_steps/templates/fabrication_steps.rb'

Before do
  clear_mongodb
  clear_sequel_db
  TestMigration.up
  Fabrication.clear_definitions
end

After do
  TestMigration.down
end
