require 'yaml'
class Yacl::Loader
  # YamlFile loads a Properites instance from a single yaml file.
  #
  # Examples:
  #
  #   yd = YamlFile.new( :filename => "./config/database.yml" )
  #   props = yd.properties
  #   props.adapter #=> 'postgres'
  #
  # You may also create a YamlFile and have it use the propety from a Properites
  # instance to indicate the directory to load from.
  #
  #   other_props.config.file # => ./config/database.yml
  #
  #   yd = YamFile.new( :properties => other_props, :parameter => 'config.file' )
  #
  #   props = yd.properties
  #   props.adapter # => postgre
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
      # Internal: load a Properties from the given filename.
      #
      # filename - The name of the yaml file to load
      # scope    - scope the loaded Properties by the given scope
      #
      # Returns a Properties instance.
      def validate_and_load_properties( filename, scope = nil )
        validate_file( filename )
        YamlFile.load_properties( filename, scope )
      end

      # Internal: Validate that the give Pathname is a valid, readable file
      #
      def validate_file( filename )
        raise Error, "#{filename} does not exist" unless File.exist?( filename )
        raise Error, "#{filename} is not readable" unless File.readable?( filename )
      end

      # Internal: load a Properties from the given filename.
      #
      # filename - The name of the yaml file to load
      # scope    - scope the loaded Properties by the given scope
      #
      # Returns a Properties instance.
      def load_properties( filename, scope )
        loaded = ::YAML.load_file( filename )
        raise Error, "#{filename} does not contain a top level hash" unless loaded.kind_of?( Hash )

        p = Yacl::Properties.new( loaded )
        return scoped( p, scope, filename )
      end

      # Internal: scope the given Properties that are loaded from the given
      # filename.
      #
      # p        - The Properties to scope by scope
      # scope    - The scope to apply to p
      # filename - The filename from which Properties was loaded
      #
      # Raises Error if the scope does not exist
      #
      # Returns a new Properties instance.
      def scoped( p, scope, filename )
        return p unless scope
        raise Error, "#{filename} does not contain a top level scope of '#{scope}'. Options are #{p.scopes.join(", ")}" unless p.has_scope?( scope )
        return p.scoped_by( scope )
      end
    end
  end
end
