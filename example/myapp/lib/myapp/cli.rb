require 'myapp/defaults'
module MyApp
  # In this example I am encapsulating everything that has to do with a
  # commandline program within the Cli module. For this example, there is one
  # and only one commandline program.
  module Cli

    # The Commandline options for our program. This maps the commandline
    # options, given in the :long and :short style for consistency in
    # commandline functionalyt to their property names which have a dotten
    # notation and make property access consistent throughout the program.
    #
    # These Options are to be used by the Parser class.
    class Options < Yacl::Define::Cli::Options
      opt 'pipeline.dir', :long => 'pipeline-dir', :short => 'd', :description => "The pipeline directory we are using", :cast => :string
      opt 'config.dir'  , :long => 'config-dir',   :short => 'c', :description => "The directory to load configuration from", :cast => :string
      opt 'timelimit'   , :long => 'time-limit',   :short => 't', :description => "The amount of time to run for", :cast => :integer
      opt 'system'      , :long => 'system',       :short => 's', :description => "The system setting", :cast => :string
      opt 'debug'       , :long => 'debug',        :sortt => 'D', :description => "Turn on debugging", :cast => :boolean
     end

    # The Parser class. This is kept explicitly separate from the Options class
    # so that, you may, if you like use whatever commadnline parser
    # library/program you whish. By default this library will automatically use
    # trollop and generate a commandline for you from it. If you whish to use
    # another commandline library, you may define your own Parser class.
    #
    # Use Yacl::Define::Cli::Parser as a template for how you would like to do
    # your work. YOu can probably get by with inheriting from
    # Yacl::Define::Cli::Parser and overwriting the #delegate_parser and #parse
    # methods.
    class Parser < Yacl::Define::Cli::Parser
      banner "myapp [options]+"
      options MyApp::Cli::Options
    end

    # The Plan class, this defines the order of loading of your properties and the
    # order of resolution of when looking up a property. The property Loaders
    # are loaded in the defined order below, and that is their priority. For
    # example the 'config.dir' property may be defiend in the Parser and the
    # Environment, and in this case if it has a value in the Env but not the
    # Parser the Env value will take precidence. If there is a value in the
    # Parser though, that will be the value used.
    #
    # In this case, since we know that this plan has a commandline, we're
    # catching any load errors and printing out to stderr on a failure. If this
    # perhaps was used in a non-commandline situation the on_error block could
    # do something completely different.
    class Plan < Yacl::Define::Plan

      # 1) parse the commandline and load properties from the mapping of the
      # commandline to the property names.
      try MyApp::Cli::Parser

      # 2) using the environment and only those environment variables that
      # start with MY_APP load additional properties.
      try Yacl::Loader::Env, :prefix => 'MY_APP'

      # 3) using the config.dir value, which is probably set via the
      # --config-dir parser option, or via the MY_APP_CONFIG_DIR environment
      # variable laod up some more properties.
      try Yacl::Loader::YamlDir, :parameter => 'config.dir'

      # 4) if a property is not found in any of the previous locations, then use
      # the defaults. And if it is not in the defaults, then we will return nil
      try MyApp::Defaults

      # If an error happens while attempting to load the properties the print a
      # message on stderr and exit the program.
      on_error do |exception|
        $stderr.puts "ERROR: #{exception}"
        $stderr.puts "Try --help for help"
        exit 1
      end
    end

    # The Runner class, this is what is instantiated in the bin script and
    # invoked from the commandline. It uses the Plan and a #run method you
    # define to take actione.
    #
    # In this particular case, it just prints out the properties.
    class Runner < ::Yacl::Define::Cli::Runner
      plan MyApp::Cli::Plan

      def run
        p = plan.properties
        puts p.map.inspect
      end
    end

  end
end
