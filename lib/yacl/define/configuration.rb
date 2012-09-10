module Yacl::Define
  class Configuration
    class Error< ::Yacl::Error; end
    class Item
      def initialize( klass, options )
        @loader_klass = klass
        @options      = options
      end

      def configuration( loader_params )
        opt = @options.merge( loader_params )
        Yacl::Configuration.new( @loader_klass.new( opt ) )
      end
    end

    # Internal:
    #
    # Returns: an Array of Items
    def self.items
      @items ||= []
    end

    def self.try( klass , options = {} )
      items << Item.new( klass, options )
    end

    def items
      self.class.items
    end

    def initialize( params = {} )
      @configurations = []
      loader_params = params.merge( :configuration => self )
      self.class.items.each do |item|
        cfg = item.configuration( loader_params )
        puts cfg.properties.inspect
        @configurations << cfg

      end
    end

    def get( property_name )
      @configurations.find do |cfg|
        if cfg.has_key?( property_name )then
          cfg.get( property_name )
        else
          false
        end
      end
    end
  end
end
