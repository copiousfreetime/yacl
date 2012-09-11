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
    # The properites that are passed in to use should we need them while loading
    #
    # Returns: Properites
    def reference_properties
      @options[:properties]
    end
  end
end
require 'yacl/loader/env'
require 'yacl/loader/yaml_file'
require 'yacl/loader/yaml_dir'
