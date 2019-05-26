class Fabrication::Schematic::Loader
  def initialize(manager)
    @manager = manager
  end

  def preinitialize
    @initializing = true
    @manager.clear
  end

  def initializing?
    @initializing ||= nil
  end

  def freeze
    @initializing = false
  end

  def load_definitions
    preinitialize
    Fabrication::Config.path_prefixes.each do |prefix|
      Fabrication::Config.fabricator_paths.each do |folder|
        Dir.glob(File.join(prefix.to_s, folder, '**', '*.rb')).sort.each do |file|
          load file
        end
      end
    end
  rescue Exception => e
    raise e
  ensure
    freeze
  end

  def load_schematic(name)
    raise Fabrication::MisplacedFabricateError.new(name) if initializing?
    load_definitions if @manager.empty?
    @manager[name] || raise(Fabrication::UnknownFabricatorError.new(name))
  end
end
