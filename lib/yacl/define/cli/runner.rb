module Yacl::Define::Cli
  # The Runner class is to be used by app developers as the basis for the
  # applications commandline program. It integrates with the plan
  # loading and allows for a cascading plan to happen
  class Runner

    def self.run( argv = ARGV, env = ENV )
      r = self.new( argv, env )
      r.run
    end

    def self.plan( *args )
      @plan_klass = args.first unless args.empty?
      return @plan_klass
    end

    attr_reader :plan

    def initialize( argv = ARGV, env = ENV )
      raise Error, "No plan class specified in #{self.class}" unless self.class.plan
      @plan = self.class.plan.new( :argv => argv, :env => env )
    end
  end
end

