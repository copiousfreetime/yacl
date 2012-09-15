require 'yacl/loader/yaml_file'
class Yacl::Loader
  # YamlDir uses a directory of yaml files to load a Properties instance.
  # It does so as if the entire directory were one big yaml file.
  #
  # Examples:
  #
  # Given the following directory structure -
  #
  #   ./config
  #   ├── database.yml
  #   ├── httpserver.yml
  #   └── pipeline.yml
  #
  # And Creating a YamlDir instance -
  #
  #   yd    = YamlDir.new( :directory => "./config" )
  #
  # Then you will have propertes like these.
  #
  #   props = yd.properties
  #
  #   props.dataabase.adapter # => postgre
  #   props.httpserver.port   # => 80
  #
  # You may also create a YamlDir and have it use the propety from a Properites
  # instance to indicate the directory to load from.
  #
  #   other_props.config.dir   # => ./config
  #
  #   yd = YamlDir.new( :properties => other_props, :parameter => 'config.dir' )
  #
  #   props = yd.properties
  #   props.dataabase.adapter # => postgre
  #   props.httpserver.port   # => 80
  #
  # This latter approach use what is used when incorparting a commandline option
  # of a configuration directory within a Plan and the loading of the
  # configuration directory after the pipeline is parsed.
  #
  #   class MyPlan < ::Yacl::Define::Plan
  #     try MyApp::Cli::Parser
  #     try Yacl::Loader::YamlDir, :parameter => 'config.dir'
  #   end
  #
  # Since this use of YamlDir is part of a Plan, the Plan will pass in the
  # Properties accumulated so far to YamlDir
  #
  class YamlDir < ::Yacl::Loader
    class Error < ::Yacl::Loader::Error; end

    # Public: Create a new instance of YamlDir
    #
    # opts - A Hash of options
    #        :direcotory - The filesystem path to the directory to load
    #        :properties - A Properties instance to use in conjunction with
    #                      :parameter
    #        :pararmeter - The parameter to look up within the Properties that
    #                      passed in with :properites in order to populate
    #                      :directory
    #        :scope      - Scope the loded Properties by this value and only
    #                      return that subset from #properties
    #
    def initialize( opt = {} )
      super
      @dirname   = options[:directory]
      @parameter = YamlDir.mapify_key( options[:parameter] )

      if (not @dirname) and (reference_properties and @parameter) then
        @dirname = reference_properties.get( *@parameter )
      end

      @scope     = options[:scope]
      YamlDir.validate_directory( @dirname )
    end

    # Public: Return the Properites that are described by the this YamlDir
    # instance
    #
    # Returns a Properties instance
    def properties
      YamlDir.validate_and_load_properties( @dirname, @scope )
    end

    class << self

      # Internal: Return param split on "." 
      #
      # This will only be done if param is a String
      #
      # Returns an Array or param
      def mapify_key( param )
        return param unless param.kind_of?( String )
        return param.split('.')
      end

      # Internal: Validate the directory and then load the properties.
      #
      # dirname - The directory from which to load properties
      # scope   - Apply the given scope to the loaded properties
      #
      # Returns a Properties instance.
      def validate_and_load_properties( dirname , scope = nil )
        validate_directory( dirname )
        YamlDir.load_properties( dirname, scope )
      end

      # Internal: Validate the given directory.
      #
      # 1) make sure it is not nil
      # 2) make sure that it exists
      # 3) make sure that it is a directory
      #
      # Raise an error if any of the above fail
      #
      # Returns nothing.
      def validate_directory( dirname )
        raise Error, "No directory specified" unless dirname
        raise Error, "#{dirname} does not exist" unless File.exist?( dirname )
        raise Error, "#{dirname} is not a directory" unless File.directory?( dirname )
      end

      # Interal: Load the proprerties scoped by the given scope
      #
      # dirname - The directory from which to load properties
      # scope   - Apply the given scope to the loaded properties
      #
      # Returns a Properties instance.
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
