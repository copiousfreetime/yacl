require 'map'

module Yacl
  class Configuration
    def initialize( loader = nil )
      @loader = loader
      @map    = loader.map
    end

    # Delegate all calls to the internal map
    def method_missing( method, *args, &block )
      @map.send( method, *args, &block )
    end

  end
end
