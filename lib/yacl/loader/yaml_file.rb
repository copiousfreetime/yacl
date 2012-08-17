require 'yaml'
module Yacl
  class Loader
    # Yaml loads a Configuration object from a Filename
    #
    class YamlFile < ::Yacl::Loader
      class Error < ::Yacl::Loader::Error; end

      def initialize( filename, scope = nil )
        super()
        @filename = filename
        @scope    = scope
        @map      = YamlFile.validate_and_load_config( @filename, @scope )
      end

      class << self
        def validate_and_load_config( filename, scope = nil )
          validate_file( filename )
          YamlFile.load_config( filename, scope )
        end

        # Validate that the give filename is a valid, readable file
        #
        def validate_file( filename )
          raise Error, "#{filename} does not exist" unless File.exist?( filename )
          raise Error, "#{filename} is not readable" unless File.readable?( filename )
        end


        # Given the input filename and a scope, load the yaml file into the @map
        #
        def load_config( filename, scope )
          loaded = ::YAML.load_file( filename )
          raise Error, "#{filename} does not contain a top level hash" unless loaded.kind_of?( Hash )

          m = Map.new( loaded )
          return scoped( m, scope, filename )
        end

        def scoped( m, scope, filename )
          return m unless scope
          raise Error, "#{filename} does not contain a top level scope of '#{scope}'. Options are #{m.keys.join(", ")}" unless m.has_key?( scope )
          m.get( scope )
        end
      end
    end
  end
end
