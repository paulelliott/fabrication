module Fabrication
  class Railtie < Rails::Railtie
    initializer 'fabrication.set_fixture_replacement' do
      # Rails 3.0.1 and up uses `app_generators`
      generators =
        if config.respond_to?(:app_generators)
          config.app_generators
        else
          config.generators
        end

      generators.fixture_replacement :fabrication unless generators.rails.key?(:fixture_replacement)
    end
  end
end
