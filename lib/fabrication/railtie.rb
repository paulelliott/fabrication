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

      unless generators.rails.has_key?(:fixture_replacement)
        generators.fixture_replacement :fabrication
      end
    end
  end
end
