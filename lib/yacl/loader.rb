require 'map'
module Yacl
  # The base class of all loaders
  class Loader
    class Error < ::Yacl::Error; end
    attr_reader :map
    def initialize
      @map = Map.new
    end

    def configuration
      Configuration.new( self )
    end
  end
end
require 'yacl/loader/env'
require 'yacl/loader/yaml_file'
require 'yacl/loader/yaml_dir'
