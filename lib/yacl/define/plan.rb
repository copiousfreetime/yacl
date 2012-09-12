module Yacl::Define
  # Public: The Plan is the order an method by which the Properties of your
  # application are loaded and looked up. This is a base class from which you
  # will define your Property lookups.
  #
  # Example:
  #
  #   class MyPlan < Yacl::Define::Plan
  #     try MyApp::Cli::Parser
  #     try Yacl::Loader::Env, :prefix => 'MY_APP'
  #     try Yacl::Loader::YamlDir, :parameter => 'config.dir'
  #     try MyApp::Defaults
  #
  #     on_error do |exception|
  #       $stderr.puts "ERROR: #{exception}"
  #       $stderr.puts "Try --help for help"
  #       exit 1
  #     end
  #   end
  #
  # This creates a class MyPlan that when utilized by a Runner loads properties
  # in the following cascading order:
  #
  # 1) Commandline is parsed and converted to Properties, these have the highest
  #    priority
  # 2) The environemtn variables are used, only those that start with 'MY_APP'
  #    as the variable prefix. These have the 2nd higest priority
  # 3) A configuration directory is loaded, using the 'config.dir' parameter
  #    that comes from either (1) or (2). Properties found in this config dir
  #    hve the 3rd highest priority
  # 4) Built in defaults if the property is not found any any of the previous
  #    locations.
  #
  class Plan
    class Error < ::Yacl::Error; end

    # Internal: An internal class used to encapsulate the individual items of
    # the lookup plan.
    class Item
      # Internal: Create a new Item. Thiis is what is created from a call to
      # Plan.try
      def initialize( klass, options )
        @loader_klass = klass
        @options      = options
      end

      # Internal: load hte properties from the given Loader class
      #
      # Returns a Properites instance
      def load_properties( params )
        opt    = @options.merge( params )
        loader = @loader_klass.new( opt )
        loader.properties
      end
    end

    class << self
      # Public: Add the given Loader child class or Loader duck-type class to the
      # definition of the Plan.
      #
      # klass   - A Class that implements the Loader API.
      # options - A Hash that will be passed to klass.new() when the klass is
      #           initialized
      #
      # Example:
      #
      #     try Yacl::Loader::YamlDir, :parameter => 'config.dir'
      #
      # Returns nothing.
      def try( klass , options = {} )
        items << Item.new( klass, options )
      end

      # Public: Define a callable to be invoked should an error happen while
      # loading the properties of your application.
      #
      # callable - the Callable to be invoked.
      #
      # Example:
      #
      #   on_error( Proc.new{ fail "kaboom!" } )
      #
      #   on_error do
      #     raise "Kaboom!"
      #   end
      #
      # Return the callable if no parameters are given and the callable is
      # defined.
      #
      # Raises an error if no parameters are given and the callable is NOT
      # defined.
      #
      def on_error( callable = nil, &block )
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

      # Internal: Test to see if this class has an on_error callable defined.
      #
      # Returns true or false if the on_error is defined.
      def has_on_error?
        defined? @on_error
      end

      # Internal: Return the array of Items that are used in the child class
      # definition.
      #
      # Returns: an Array of Items
      def items
        @items ||= []
      end
    end

    # Internal: Return the array of Items defined for this class
    #
    # Returns an Array of Items.
    def items
      self.class.items
    end

    # Public: Return the Properties instance that results from instantiating the
    # Plan.
    #
    # Returns an Properties instance.
    attr_reader :properties

    # Public: Create a new instance of the Plan. This should be invoked via
    # #super in a child class.
    #
    def initialize( params = {} )
      initial_properties = params[:initial_properties] || Yacl::Properties.new
      @properties = load_properties( initial_properties, params, items )
    rescue Yacl::Error => ye
      if self.class.has_on_error? then
        self.class.on_error.call( ye )
      else
        raise ye
      end
    end

    #######
    private
    #######

    # Internal: Create the Proprites from an initial properties, a set of params
    # and the list of Items in the class.
    #
    # initial_properties - a blank Properites, or an initialized Properties
    #                      instance to use as the highest priority properites
    # params             - A Hash that will be passed to each Item when it is
    #                      loaded.
    # items              - An Array of Item instances
    #
    # The properties are loaded in definitiaion order, that is the order they
    # appear in the class definition. The initial properties are recalculated on
    # each iteration as the next Properites may use some information from the
    # previous Properties to load itself.
    #
    # The final Properties that is returned is a merging of all the loaded
    # properties in reverse order from the bottom to the top. This results in
    # the last Item defined with #try being the "bottom" property with the last
    # priority. It may be overwritten by any of the Properties that are loaded
    # from higher in the loader stack
    #
    # Returns a Properties instance.
    def load_properties( initial_properties, params, items )
      loaded_properties = [ initial_properties ]
      items.each do |item|
        properties_so_far = merge_properties( loaded_properties )
        item_params       = params.merge( :properties => properties_so_far )
        loaded_properties << item.load_properties( item_params )
      end
      return merge_properties( loaded_properties )
    end

    # Internal: Merge a list of Properties instances in the reverse order of the
    # Array in which they exist
    #
    # properties_list - an Array of Properites
    #
    # Returns a Properties instances.
    def merge_properties( properties_list )
      props = ::Yacl::Properties.new
      properties_list.reverse.each do |p|
        props.merge!( p )
      end
      return props
    end
  end
end
