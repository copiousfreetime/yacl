module Yacl
  class Simple

    class << self
      # Public: Create a child class of Yacl::Define::Defaults
      def defaults( &block )
        klass = Class.new( Yacl::Define::Defaults )
        klass.class_eval( &block )
        return klass
      end

      # Public: Creates a child class of Yacl::Define::Cli::Parser
      def parser( &block )
        klass = Class.new( Yacl::Define::Cli::Parser )
        klass.class_eval( &block )
        return klass
      end
    end
  end
end
