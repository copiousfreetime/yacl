module Yacl
  class Simple
    class << self
      # Public: Create a child class of Yacl::Define::Defaults
      def defaults( &block )
        nested_class( 'Defaults', Yacl::Define::Defaults, &block )
      end

      # Public: Creates a child class of Yacl::Define::Cli::Parser
      def parser( &block )
        nested_class( 'Parser', Yacl::Define::Cli::Parser, &block )
      end
      # Internal: Define a class that is a nested class of the module
      def nested_class( name, parent, &block )
        unless const_defined?( name ) then
          klass = Class.new( parent )
          klass.class_eval( &block )
          const_set( name , klass )
        end
        return const_get( name )
      end

    end
  end
end
