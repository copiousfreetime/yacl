require 'map'
module Yacl
  # The base class of all loaders
  class Loader
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
