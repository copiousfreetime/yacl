module Yacl
  module Define
    # Public: A base class for use in defining your application's default
    # configuration properties.
    #
    # For the API purposes, classes that inherit from Defaults may behave as
    # both Loader and Properties classes.
    #
    # Examples:
    #
    #   class MyDefaults < Yacl::Define::Defaults
    #     default 'host.name', 'localhost'
    #     default 'host.port', 4321
    #   end
    #
    # Now you can use an instances of MyDefaults to find your defaults
    #
    #   d = MyDefaults.new
    #   d.host.name               # => 'localhost'
    class Defaults
      class Error< ::Yacl::Error; end
      extend Forwardable

      # Internal: Create the instance of Properties that will be populated by
      # calls to Properties::default.
      #
      # Returns: Properties
      def self.properties
        @properties ||= ::Yacl::Properties.new
      end

      # Public: Define a property and its value.
      #
      # name  - The String name of the property.
      # value - The obj to be the default value for the given name.
      #
      # Returns nothing.
      def self.default( name, value )
        args = name.to_s.split('.')
        args << value
        properties.set( *args )
      end

      # Behave as if we are an instance of Properties
      def_delegators :@properties, *Properties.delegatable_methods

      # Internal: Return the Properties so we behave like a Loader
      attr_reader :properties

      # Internal: Fake out being a Loader.
      #
      # This method is here to implement the LoaderAPI
      #
      # Returns nothing.
      def initialize( opts = {} )
        @properties = self.class.properties
      end
    end
  end
end
