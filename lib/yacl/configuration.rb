module Yacl
  # Public: The base class to be used when implementing your applications
  # configuration clas.
  #
  # A Configuration is the combination of a Loader and a Properties.
  # It is initialized with a Loader and then keeps the loaded Properties in
  # itself. It delegates all the Properties methods to its instance of
  # Properties
  #
  class Configuration
    extend Forwardable

    # Send all lookups to the properties
    def_delegators :@properties, *Properties.delegatable_methods

    # Internal: Returns the Properties of this Configuration
    attr_reader :properties

    def initialize( loader = nil )
      @loader     = loader
      @properties = loader.properties
    end
  end
end
