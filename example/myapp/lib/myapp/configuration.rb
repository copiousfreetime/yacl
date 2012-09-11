require 'yacl'
require 'myapp/cli'
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
  end

  class Defaults < Yacl::Define::Defaults
    default 'archive.uri'    , 'http://archive.collectiveintellect.com'
    default 'messaging.uri'  , 'kestrel://messaging1.collectiveintellect.com:2229/'
    default 'messaging.queue', 'frankensnip'
    default 'system'         , 'pipeline_main'
    default 'timelimit'      , '10'
  end

  class Configuration < Yacl::Define::Configuration
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

end


