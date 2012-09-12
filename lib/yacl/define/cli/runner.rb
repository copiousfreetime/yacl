module Yacl::Define::Cli
  # Public: The Runner class is to be used by app developers as the entry point
  # for the commandline programs. A class that inherits from Runner is what is
  # placed in a bin/myapp file in the project structure.
  #
  # The Runner is configured with the Plan to use for loading the configuratin
  # properties and when the plan is loaded, the properties are available via the
  # #properties method.
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
  # And in your 'bin/myapp-cli' file you would have:
  #
  #   # automatically populate with ARGV and ENV
  #   MyApp::Runner.go
  #
  #   # or be explicit
  #   MyApp::Runner.go( ARGV, ENV )
  #
  class Runner
    class Error < ::Yacl::Error; end

    # Public: Execute the Runner
    #
    # argv - The commandline args to use (default: ARGV)
    # env  - The enviroment hash to use  (default: ENV )
    #
    # It is assumed that when this method exits, the program is over.
    #
    # Returns nothing.
    def self.go( argv = ARGV, env = ENV )
      r = self.new( argv, env )
      r.run
    end

    # Public: Define the Plan associated with this Runner.
    #
    # plan - A class you define that inherits from Yacl::Define::Plan
    #
    # Returns: the plan class if it is set, nil otherwise.
    def self.plan( *args )
      @plan_klass = args.first unless args.empty?
      return @plan_klass
    end

    # Internal: Initalize the Runner.
    #
    # argv - The commandline args to use (default: ARGV)
    # env  - The enviroment hash to use  (default: ENV )
    #
    # This method should be avoided by end users, they should call #go instead.
    def initialize( argv = ARGV, env = ENV )
      raise Error, "No plan class specified in #{self.class}" unless self.class.plan
      @plan = plan_klass.new( :argv => argv, :env => env )
    end

    # Public: Access the Properties instance that is created by the Plan. This
    # is the fully realized Properties of the plan and should be considered
    # read-only.
    #
    # Returns a Properties instance.
    def properties
      @plan.properties
    end

    # Internal: return the Plan class defined for this Runner class
    #
    # Returns a Plan class
    def plan_klass
      self.class.plan
    end
  end
end

