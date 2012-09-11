module Yacl::Define::Cli
  # Public:
  #
  # The Runner class is to be used by app developers as the entry point for
  # commandline programs. A class that inherits from Runner would be what is
  # placed in a bin/myapp file.
  #
  # The Runner is configuration with the Plan to use for loading the
  # configuratin properties and when the plan is loaded, the properties are
  # available via the #properties method.
  #
  # Example:
  #
  #   class MyApp::Runner < Yacl::Define::Cli::Runner
  #     plan MyApp::Plan
  #
  #     def run
  #       puts properties.database.server
  #     end
  #   end
  #
  # And then in your 'bin/myapp-cli' file you would have:
  #
  #   MyApp::Runner.go
  #
  class Runner

    # Public: Execute the Runner
    #
    # argv - The commandline args to use (default: ARGV)
    # env  - The enviroment hash to use  (default: ENV )
    #
    # It is assumed that when this method exits, the program is over.
    #
    # Returns: nothing
    def self.go( argv = ARGV, env = ENV )
      r = self.new( argv, env )
      r.run
    end

    # Public: Define the Plan associated with this Runner.
    #
    # plan - A class that inherits from Yacl::Define::Plan
    #
    # Returns: the plan class if it is set, nil otherwise.
    def self.plan( p = nil )
      @plan_klass = p if p
      return @plan_klass
    end

    # Internal: the instance of the Plan class used to load the configuration
    attr_reader :plan

    # Internal: Initalize the Runner.
    #
    # argv - The commandline args to use (default: ARGV)
    # env  - The enviroment hash to use  (default: ENV )
    #
    # This method should be avoided by end users, they should call #go instead.
    def initialize( argv = ARGV, env = ENV )
      raise Error, "No plan class specified in #{self.class}" unless self.class.plan
      @plan = self.class.plan.new( :argv => argv, :env => env )
    end
  end
end

