require 'myapp/defaults'
module MyApp
  # In this case we are assuming that the application is not part of a
  # commandline program and it may be used from some other library and it still
  # needs to load its config from some location.
  #
  # This could be the case of :
  #   - Resque or some other background job system
  #   - Part of a torquebox configuration
  #   - embedded in some other library
  module Job

    # We have a plan just as we did with the commandline one, but without the
    # commandline parser.
    class Plan < Yacl::Define::Plan
      # First try to load properties from the environment variables that start
      # with MY_PREFIX
      try Yacl::Loader::Env, :prefix => 'MY_APP'

      # Next we will load from an explicit directory.
      try Yacl::Loader::YamlDir, :path => File.expand_path( "../../../config", __FILE__ )

      # And finally we will use the built in defaults
      try MyApp::Defaults

      # On an error we just print to stderr saying that we do not know what is
      # going on. We could re-reise the exception, or just let it naturally
      # percolate up if we wanted something else to handle it.
      on_error do |exception|
        $stderr.puts exception
        $stderr.puts exception.backtrace.join("\n")
      end
    end

    # In this situation we have a class that needs to use the plan and do
    # something with it. Instead of having a commandline program, this is the
    # clasee that serves as the interface between our code and someone elses
    # code.
    class ForSomething

      # We will take a hash here so that the external program can explicitly
      # pass in as set of initial properties and have them bee the most highly
      # prioritiezed values in the plan stack.
      #
      # We also explictly use the Plan here, and do not assume that there is a
      # runner.
      def initialize( params )
        p = Yacl::Properties.new( params )
        plan = Job::Plan.new( :initial_properties => p )
        puts plan.properties.map.inspect
      end
    end
  end
end


