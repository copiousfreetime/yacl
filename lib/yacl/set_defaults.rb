module Yacl
  # Use SetDefaults to extend a class and allow it to be the encapsulation of
  # hardcoced default configuration parameters
  #
  #   class MyDefaults
  #     extend Yacl::SetDefaults
  #
  #     default 'host.name', 'localhost'
  #   end
  #
  # Now you can use either MyDefaults itself, or an instance of the MyDefaults
  # class to find your defaults.
  #
  #   puts MyDefaults.host.name # => 'localhost'
  #   d = MyDefaults.new
  #   d.host.name               # => 'localhost'
  #
  module SetDefaults
    class Error< ::Yacl::Error; end

    module ClassMethods

      def __map__
        if not defined? @__map__ then
          @__map__  = Map.new
        end
        return @__map__
      end

      def default( name, value )
        args = name.split(".")
        args << value
        __map__.set( *args )
      end

      def method_missing( method, *args )
        __map__.send( method, *args )
      end
    end

    def method_missing( method, *args )
      self.class.send( method, *args )
    end

    def self.included( klass )
      klass.extend( ClassMethods )
    end

  end
end
