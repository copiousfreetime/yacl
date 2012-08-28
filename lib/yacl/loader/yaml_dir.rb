require 'yacl/loader/yaml_file'
class Yacl::Loader
  # Yaml loads a Configuration object from a Dirname
  #
  class YamlDir < ::Yacl::Loader
    class Error < ::Yacl::Loader::Error; end

    def initialize( options = {} )
      super
      @dirname  = options.fetch( :directory )
      @scope    = options.fetch( :scope, nil )
      YamlDir.validate_directory( @dirname )
    end

    def properties
      YamlDir.validate_and_load_properties( @dirname, @scope )
    end

    class << self

      def validate_and_load_properties( filename, scope = nil )
        validate_directory( filename )
        YamlDir.load_properties( filename, scope )
      end

      # Validate that the give dirname is a valid, readable dir
      #
      def validate_directory( dirname )
        raise Error, "#{dirname} does not exist" unless File.exist?( dirname )
        raise Error, "#{dirname} is not a directory" unless File.directory?( dirname )
      end

      # Given the input dirname and a scope, load the yaml file into the @map
      #
      def load_properties( dirname, scope )
        p = Yacl::Properties.new
        Dir.glob( File.join( dirname, '*.yml') ).each do |config_fname|
          file_properties = Yacl::Loader::YamlFile.new( :file => config_fname ).properties
          namespace       = File.basename( config_fname, ".yml" )
          file_properties.each do |k,v|
            args = [ namespace, k ].flatten
            args << v
            p.set( *args )
          end
        end
        return p
      end
    end
  end
end
