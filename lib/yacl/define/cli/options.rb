module Yacl::Define::Cli

  # Internal: Encapsulation of all the elements pertaining to a single
  # commandline option.
  Option = Struct.new( :property_name, :long, :short, :description, :cast)

  # Public: Inherit from Cli::Options to define your the mapping between your
  # application properties and commandline switches.
  #
  # The class you create from here is to be used in conjuction with a class you
  # create that is a child class of Cli::Parser.
  #
  # Example:
  #
  #   class MyOptions < ::Yacl::Define::Cli::Options
  #     opt 'log.level', :long => 'log-level', :short => 'l', :description => "Logging Level", :cast => :string
  #     opt 'config.dir',:long => 'config-dir', :short => 'c', :description => "Configuration directory", :cast => :string
  #   end
  #
  #   o = MyOptions.new( 'log-level' => 'debug', 'config-dir' => '/tmp/foo' )
  #   o.properites # => Properties instance with 'log.level' => debug and 'config.dir' => '/tmp/foo'
  #
  class Options < ::Yacl::Loader

    # Internal: access to the defined list of options
    #
    # Returns the Array of options
    def self.opt_list
      @opt_list ||= []
    end

    # Public: Declare a property and its corresponding commandline options.
    #
    # name   - The property name as a String
    # params - The Hash options to accompany the property name (default: {})
    #          :long        - The long commandline option. Without leading dashes
    #          :short       - The short commandline option. Without leading dashes
    #          :description - The text description of this commandline option
    #          :cast        - What to cast the value of the commandline option
    #                         to. This can be one of: :integer, :float, :string,
    #                         :boolean
    #
    # Examples:
    #
    #   opt 'app.thing.one', :long => 'thing-one', :short => 't', :description => "Thing One", :cast => :string
    #
    # Returns nothing.
    def self.opt(name, params = {} )
      opt_list << Option.new( name, params[:long], params[:short], params[:description ], params[:cast] )
    end

    # Public: Load the Properties from the options that were passed to the
    # initializer.
    #
    # Returns a Properties instance.
    def properties
      load_properties( @options )
    end

    # Public: yield each defined Option in this class to the caller
    #
    # Yields the Option instance of the iteration.
    #
    # Returns nothing.
    def each
      opt_list.each do |o|
        yield o
      end
    end

    # Internal: Return the list of defined options for this Class.
    #
    # Returns an Array of Option instances
    def opt_list
      self.class.opt_list
    end

    # Internal: convert the given hash of long options into a Properties
    # instance using the defined options.
    #
    # It is assumed that the commandline has already been parsed and that the
    # hash passed in is the long options that were parsed out of the
    # commandline.
    #
    # hash - a Hash of long options and their values.
    #
    # Returns a Properties instance
    def load_properties( hash )
      prop_hash = {}
      opt_list.each do |o|
        next unless hash.has_key?( o.long )
        prop_hash[o.property_name] = hash[o.long]
      end
      return Yacl::Properties.new( prop_hash )
    end
  end
end
