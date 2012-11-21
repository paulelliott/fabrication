require 'bundler'

Bundler.require(:default, :development)

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

RSpec.configure do |config|
  Turnip::Config.step_dirs = ['turnip', File.expand_path('lib/rails/generators/fabrication/turnip_steps/templates/')]
  config.before(:each) do
    TestMigration.up
    clear_mongodb
  end
end
