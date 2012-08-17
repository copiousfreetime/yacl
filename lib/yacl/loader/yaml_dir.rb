require 'yaml'
module Yacl
  class Loader
    # Yaml loads a Configuration object from a Dirname
    #
    class YamlDir < ::Yacl::Loader
      class Error < ::Yacl::Loader::Error; end

      def initialize( dirname, scope = nil )
        super()
        @dirname  = dirname
        @scope    = scope
        validate_dir( @dirname )
        @map      = load_config( @dirname, @scope )
      end

      private

      # Validate that the give dirname is a valid, readable dir
      #
      def validate_dir( dirname )
        raise Error, "#{dirname} does not exist" unless File.exist?( dirname )
        raise Error, "#{dirname} is not a directory" unless File.directory?( dirname )
      end

      # Given the input dirname and a scope, load the yaml file into the @map
      #
      def load_config( dirname, scope )
        map = Map.new
        Dir.glob( File.join(@dirname, '*.yml') ).each do |config_fname|
          file_map  = Yacl::Loader::YamlFile.new( config_fname ).map
          namespace = File.basename( config_fname, ".yml" )
          map.set( namespace, file_map )
        end
        return map
      end
    end
  end
end

