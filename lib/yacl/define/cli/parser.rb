require 'trollop'
module Yacl::Define::Cli
  # Parser is a wrapper around the trollop parser, and it is also a loader
  class Parser < ::Yacl::Loader

    # Takes a class that when instantiated with no options may be used as an
    # enumerable of Cli::Option instances
    def self.options( *args )
      @options_klass = args.first unless args.empty?
      return @options_klass
    end

    # Public
    def self.banner( *args )
      @banner = args.first unless args.empty?
      @banner ||= "Usage  :  #{File.basename($0)} [options]+\nOptions:"
    end

    def banner
      self.class.banner
    end

    def initialize( opts = {} )
      super
      @argv = opts[:argv]
    end

    def properties
      h = parse( @argv )
      o = options_klass.new( h )
      o.properties
    end

    private

    def options_klass
      self.class.options
    end

    def delegate_parser
      trollop_options = options_klass.new
      Trollop::Parser.new do
        banner trollop_options.banner
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
