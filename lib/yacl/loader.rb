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

    def initialize( opts = {} )
      @options = opts
    end

    # Internal:
    #
    # Load the properties according to the type of loader it is
    #
    # Returns: Properties
    def properties
      Properties.new
    end
  end
end
require 'yacl/loader/env'
require 'yacl/loader/yaml_file'
require 'yacl/loader/yaml_dir'
