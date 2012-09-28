require 'trollop'
module Yacl::Define::Cli
  # Public: Parser is a Loader that uses a Cli::Options class and the Trollop
  # parser to convert commandline options into a Properties instance. It is to
  # be inherited from so you can have your own parser per commandline program in
  # your application suite.
  #
  # Example:
  #
  #   class MyOptions < ::Yacl::Define::Cli::Options
  #     opt 'log.level', :long => 'log-level', :short => 'l', :description => "Logging Level", :cast => :string
  #     opt 'config.dir',:long => 'config-dir', :short => 'c', :description => "Configuration directory", :cast => :string
  #   end
  #
  #   class MyParser < ::Yacl::Define::Cli::Parser
  #     banner "Usage: myapp [options]+"
  #     options MyOptions
  #   end
  #
  #   p = MyParser.new( :argv => ARGV )
  #   p.properties #=> a Properties instance
  #
  class Parser < ::Yacl::Loader

    # Public: Define the options Class that is be used by this Parser, or return
    # the existin Class if it is already defined.
    #
    # klass - A Class that is a child class of Cli::Options.
    #
    # Returns the current options Class.
    def self.options( *args )
      @options_klass ||= args.first unless args.empty?
      return @options_klass
    end

    # Public: Set or retrieve the banner text.
    #
    # text - A String to be displayed as part of the help text.
    #
    # Returns the value set, or the default value if one is not set.
    def self.banner( *args )
      @banner = args.first unless args.empty?
      @banner ||= "Usage  :  #{File.basename($0)} [options]+\nOptions:"
    end

    # Public: Define a commandline option for this Parser.
    # Using 'opt' over options will dynamically create a child class of Options
    # for use by this class
    def self.opt( *args )
      options( Class.new( Yacl::Define::Cli::Options ) )
      options.opt( *args )
    end

    # Create a new Parser instance
    #
    # opts - The hash of options for this Loader
    #        :argv - The commandline options passed to the Parser.
    #        other options as per the Loader class.
    #
    def initialize( opts = {} )
      super
      @argv = opts[:argv] || []
    end

    # Public: Retrive the class level banner text.
    #
    # Returns the String banner text
    def banner
      self.class.banner
    end

    # Public: Return the Properties instance that is created by parsing the
    # commandline options.
    #
    # Nil values from possible defaults from the commandline parser are
    # filtered out before being merged onto the options.
    #
    # Returns a Properties instance.
    def properties
      h = {}
      parse( @argv ).each do |k,v|
        h[k] = v unless v.nil?
      end
      o = options_klass.new( h )
      o.properties
    end

    private

    # Internal: Return the class level value stored in Parser#options
    #
    # Returns a Class
    def options_klass
      self.class.options
    end

    def delegate_parser
      Trollop::Parser.new( options_klass.new, self.banner ) do |trollop_options, banner_text|
        text banner_text
        trollop_options.each do |x|
          opt x.long, x.description, :type => x.cast
        end
      end
    end

    def parse( argv )
      Trollop::with_standard_exception_handling( delegate_parser ) do
        delegate_parser.parse( argv )
      end
    end
  end
end
