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

    def self.has_on_error?
      defined? @on_error
    end

    def self.on_error( callable = nil, &block )
      if callable then
        @on_error = callable
      elsif block_given?
        @on_error =  block
      elsif defined? @on_error
        return @on_error
      else
        raise Error, "on_error requires the use of a callable or a block"
      end
    end

    def items
      self.class.items
    end

    attr_reader :properties

    def initialize( params = {} )
      @properties = load_properties( params, items )
    rescue Yacl::Error => ye
      if self.class.has_on_error? then
        self.class.on_error.call( ye )
      end
    end

    extend Forwardable
    # Behave as if we are an instance of Properties
    def_delegators :@properties, *Yacl::Properties.delegatable_methods

    private

    def load_properties( params, items )
      loaded_properties = []
      items.each do |item|
        properties_so_far = merge_properties( loaded_properties )
        item_params = params.merge( :properties => properties_so_far )
        loaded_properties << item.load_properties( item_params )
      end
      return merge_properties( loaded_properties )
    end

    def merge_properties( properties_list )
      props = ::Yacl::Properties.new
      properties_list.reverse.each do |p|
        props.merge!( p )
      end
      return props
    end
  end
end
