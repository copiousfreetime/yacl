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

    def initialize( opts = {} )
      super
      @argv = opts[:argv] || ARGV
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
        raise Trollop::HelpNeeded if argv.empty?
        delegate_parser.parse( argv )
      end
    end
  end
end
