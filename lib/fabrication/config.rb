module Fabrication
  module Config
    extend self

    def configure; yield self end

    def reset_defaults
      @fabricator_path =
        @path_prefix =
        @active_support =
        @sequence_start =
        nil
    end

    def fabricator_path
      @fabricator_path ||= ['test/fabricators', 'spec/fabricators']
    end

    def fabricator_dir
      puts "DEPRECATION WARNING: Fabrication::Config.fabricator_dir has been replaced by Fabrication::Config.fabricator_path"
      fabricator_path
    end

    def fabricator_path=(folders)
      @fabricator_path = (Array.new << folders).flatten
    end

    def fabricator_dir=(folders)
      puts "DEPRECATION WARNING: Fabrication::Config.fabricator_dir has been replaced by Fabrication::Config.fabricator_path"
      fabricator_path = folders
    end

    attr_writer :sequence_start
    def sequence_start; @sequence_start ||= 0 end

    attr_writer :path_prefix
    def path_prefix
      @path_prefix ||= defined?(Rails) ? Rails.root : "."
    end

    attr_writer :register_with_steps
    def register_with_steps?; @register_with_steps end
  end
end
