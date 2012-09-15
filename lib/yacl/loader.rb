require 'pathname'
module Yacl
  # Loader - the base class of all Loaders. It defines the Loader API>
  #
  # The Loader API is:
  #
  #   1) The initializer method takes an Hash. This hash is stored in the
  #      @options and is avaialble to all child clasess via the #options
  #      method.
  #
  #   2) The #properties method takes no parameters and MUST return a Properties
  #      instance
  #
  #   3) If the options passed into the initializer has a :reference_properites
  #      key, its value is made available via the #reference_properties method.
  #
  # Loader also provides a couple of utility methods for use by child classes.
  #
  class Loader
    class Error < ::Yacl::Error; end
    attr_reader :options

    # Internal: The configuration object this loader is associated with
    attr_reader :configuration

    # Create a new instance of the Loader
    #
    # opts - as Hash of options. Well known options are:
    #        :properties - A Properties object
    #        :path       - A directory/file path
    #
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
