require 'yaml'
require 'yacl/loader/loadable_file'
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
    include ::Yacl::Loader::LoadableFile

    def initialize( opts = {} )
      super
      @path      = YamlFile.extract_path( options )
      @scope     = options.fetch( :scope, nil )
      @parameter = YamlFile.mapify_key( options[:parameter] )

      if (not @path) and (reference_properties and @parameter) then
        @path = Pathname.new( reference_properties.get( *@parameter ) )
      end

      validate_file( @path )
    end

    def properties
      validate_and_load_properties( @path, @scope )
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
  end
end
