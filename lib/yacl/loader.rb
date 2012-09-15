require 'pathname'
module Yacl
  # Loader - the base class of all Loaders
  #
  # All loaders implement:
  #
  #   initialize( opts = {} ) and make sure to call super
  #   properties - which must return a Properties instance
  #
  class Loader
    class Error < ::Yacl::Error; end
    attr_reader :options

    # Internal: The configuration object this loader is associated with
    attr_reader :configuration

    def initialize( opts = {} )
      @options = opts
      @configuration = @options[:configuration]
    end

    # Internal:
    #
    # Load the properties according to the type of loader it is
    #
    # Returns: Properties
    def properties
      Properties.new
    end

    # Internal:
    #
    # The properties that are passed in to use should we need them while loading
    #
    # Returns: properties
    def reference_properties
      @options[:properties]
    end

    # Internal: Return param split on "."
    #
    # This will only be done if param is a String
    #
    # Returns an Array or param
    def self.mapify_key( param )
      return param unless param.kind_of?( String )
      return param.split('.')
    end

    # Internal: Extract the value from :path and covert it to a Pathname
    # If a :path key is found, then extract it and convert the value to a
    # Pathname
    #
    # options - a Hash
    # key     = the key to extract as a path (default: 'path')
    #
    # Returns a Pathname or nil.
    def self.extract_path( options, key = 'path' )
      ps = options[key.to_sym] || options[key.to_s]
      return nil unless ps
      return Pathname.new( ps )
    end
  end
end
require 'yacl/loader/env'
require 'yacl/loader/yaml_file'
require 'yacl/loader/yaml_dir'
