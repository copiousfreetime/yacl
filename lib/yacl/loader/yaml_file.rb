require 'yaml'
class Yacl::Loader
  # Yaml loads a Configuration object from a Filename
  #
  class YamlFile < ::Yacl::Loader
    class Error < ::Yacl::Loader::Error; end

    def initialize( opts = {} )
      super
      @filename = options.fetch( :file )
      @scope    = options.fetch( :scope, nil )
      YamlFile.validate_file( @filename )
    end

    def properties
      YamlFile.validate_and_load_properties( @filename, @scope )
    end

    class << self
      def validate_and_load_properties( filename, scope = nil )
        validate_file( filename )
        YamlFile.load_properties( filename, scope )
      end

      # Validate that the give filename is a valid, readable file
      #
      def validate_file( filename )
        raise Error, "#{filename} does not exist" unless File.exist?( filename )
        raise Error, "#{filename} is not readable" unless File.readable?( filename )
      end


      # Given the input filename and a scope, load the yaml file into the @map
      #
      def load_properties( filename, scope )
        loaded = ::YAML.load_file( filename )
        raise Error, "#{filename} does not contain a top level hash" unless loaded.kind_of?( Hash )

        p = Yacl::Properties.new( loaded )
        return scoped( p, scope, filename )
      end

      def scoped( p, scope, filename )
        return p unless scope
        raise Error, "#{filename} does not contain a top level scope of '#{scope}'. Options are #{p.scopes.join(", ")}" unless p.has_scope?( scope )
        return p.scoped_by( scope )
      end
    end
  end
end
