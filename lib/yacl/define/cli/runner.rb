module Yacl::Define::Cli
  # The Runner class is to be used by app developers as the basis for the
  # applications commandline program. It integrates with the configuration
  # loading and allows for a cascading configuration to happen
  class Runner

    def self.run( argv = ARGV, env = ENV )
      self.new( argv, env ).run
    end

    def self.configuration( *args )
      @configuration_klass = args.first unless args.empty?
      return @configuration_klass
    end

    attr_reader :configuration

    def initialize( argv = ARGV, env = ENV )
      raise Error, "No configuration class specified in #{self.class}" unless self.class.configuration
      @configuration = self.class.configuration.new( :argv => argv, :env => env )
    end
  end
end

