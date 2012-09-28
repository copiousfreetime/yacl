module Yacl
  class Simple < ::Yacl::Define::Cli::Runner
    class << self
      # Public: Create a child class of Yacl::Define::Defaults
      #
      # block - an optional block will be evaluated in the context of the
      #         created class.
      #
      # The child class is created once, and the block is evaluated once.
      # Further class to this method will result in returning the already
      # defined class.
      def defaults( &block )
        nested_class( 'Defaults', Yacl::Define::Defaults, &block )
      end

      # Public: Creates a child class of Yacl::Define::Cli::Parser
      #
      # block - an optional block will be evaluated in the context of the
      #         created class.
      #
      # The child class is created once, and the block is evaluated once.
      # Further class to this method will result in returning the already
      # defined class.
      def parser( &block )
        nested_class( 'Parser', Yacl::Define::Cli::Parser, &block )
      end

      # Public: Creates a child class of Yacl::Define::Plan
      #
      # block - an optional block will be evaluated in the context of the
      #         created class.
      #
      # The child class is created once, and the block is evaluated once.
      # Further class to this method will result in returning the already
      # defined class.
      def plan( &block )
        nested_class( 'Plan', Yacl::Define::Plan, &block )
      end

      # Internal: Define a class that is a nested class of the module
      def nested_class( name, parent, &block )
        unless const_defined?( name ) then
          klass = Class.new( parent )
          klass.class_eval( &block ) if block_given?
          const_set( name , klass )
        end
        return const_get( name )
      end

    end
  end
end
