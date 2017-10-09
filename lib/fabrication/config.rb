module Fabrication
  module Config
    extend self

    def configure; yield self end

    def reset_defaults
      @fabricator_path =
        @path_prefix =
        @sequence_start =
        @generators =
        nil
    end

    def fabricator_path
      @fabricator_path ||= ['test/fabricators', 'spec/fabricators']
    end
    alias fabricator_paths fabricator_path

    def fabricator_dir
      puts "DEPRECATION WARNING: Fabrication::Config.fabricator_dir has been replaced by Fabrication::Config.fabricator_path"
      fabricator_path
    end

    def fabricator_path=(folders)
      @fabricator_path = (Array.new << folders).flatten
    end

    def fabricator_dir=(folders)
      puts "DEPRECATION WARNING: Fabrication::Config.fabricator_dir has been replaced by Fabrication::Config.fabricator_path"
      self.fabricator_path = folders
    end

    attr_writer :sequence_start
    def sequence_start; @sequence_start ||= 0 end

    def path_prefix=(folders)
      @path_prefix = (Array.new << folders).flatten
    end

    def path_prefix
      @path_prefix ||= [defined?(Rails) ? Rails.root : "."]
    end
    alias path_prefixes path_prefix

    attr_writer :register_with_steps
    def register_with_steps?
      @register_with_steps ||= nil
    end

    def generators; @generators ||= [] end

    def generator_for(default_generators, klass)
      (generators + default_generators).detect { |gen| gen.supports?(klass) }
    end

    def recursion_limit; @recursion_limit ||= 20 end
    def recursion_limit=(limit); @recursion_limit = limit end
  end
end
