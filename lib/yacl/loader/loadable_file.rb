class Yacl::Loader
  class LoadableFile < ::Yacl::Loader
    class Error < ::Yacl::Loader::Error; end

    def initialize( options = {} )
      super
      @path      = self.class.extract_path( options )
      @scope     = options.fetch( :scope, nil )
      @parameter = self.class.mapify_key( options[:parameter] )

      if (not @path) and (reference_properties and @parameter) then
        @path = Pathname.new( reference_properties.get( *@parameter ) )
      end

      validate_file( @path )
    end


    # Internal: load a Properties from the given filename.
    #
    # filename - The name of the yaml file to load
    # scope    - scope the loaded Properties by the given scope
    #
    # Returns a Properties instance.
    def validate_and_load_properties( filename, scope = nil )
      validate_file( filename )
      load_properties( filename, scope )
    end

    # Internal: Validate that the give Pathname is a valid, readable file
    #
    # path - the Patname we are going to check
    #
    # Validates:
    #
    # 1) that path has a value
    # 1) that the path exists
    # 2) that the path is readable
    #
    # Raises an error if either of the above failes
    def validate_file( path )
      raise Error, "No path specified" unless path
      raise Error, "#{path} does not exist" unless path.exist?
      raise Error, "#{path} is not readable" unless path.readable?
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
