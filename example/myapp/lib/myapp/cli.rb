require 'myapp/defaults'
module MyApp
  module Cli
    class Options < Yacl::Define::Cli::Options
      banner "myapp [options]+"
      opt 'pipeline.dir', :long => 'pipeline-dir', :short => 'd', :description => "The pipeline directory we are using", :cast => :string
      opt 'config.dir'  , :long => 'config-dir',   :short => 'c', :description => "The directory to load configuration from", :cast => :string
      opt 'timelimit'   , :long => 'time-limit',   :short => 't', :description => "The amount of time to run for", :cast => :integer
      opt 'system'      , :long => 'system',       :short => 's', :description => "The system setting", :cast => :string
      opt 'debug'       , :long => 'debug',        :sortt => 'D', :description => "Turn on debugging", :cast => :boolean
     end

    class Parser < Yacl::Define::Cli::Parser
      options MyApp::Cli::Options
    end

    class Plan < Yacl::Define::Plan
      try MyApp::Cli::Parser
      try Yacl::Loader::Env, :prefix => 'MY_APP'
      try Yacl::Loader::YamlDir, :parameter => 'config.dir'
      try MyApp::Defaults

      on_error do |exception|
        $stderr.puts "ERROR: #{exception}"
        $stderr.puts "Try --help for help"
        exit 1
      end
    end

    class Runner < ::Yacl::Define::Cli::Runner
      plan MyApp::Cli::Plan

      def run
        p = plan.properties
        puts p.map.inspect
      end
    end
  end
end
