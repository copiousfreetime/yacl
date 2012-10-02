require 'yacl'
module MyApp
  # This is a simplier version of 'myapp' example where we use a DSL instead of
  # explicit classes. Under hte covers, this creats classes that do the same as
  # the explicit version.
  #
  # For simpler cases where you want to put all of this together this may make
  # more sense.
  class Application < ::Yacl::Simple

    # This defines a MyApp::Application::Defaults class. This class is also
    # available via MyApp::Application.defaults
    defaults do
      default 'archive.uri'    , 'http://archive.example.com'
      default 'messaging.uri'  , 'kestrel://messaging1.example.com:2229/'
      default 'messaging.queue', 'pending'
      default 'system'         , 'main'
      default 'timelimit'      , '10'
    end

    # This defines a MyApp::Application::Parser class. This class is also
    # available via MyApp::Application.parser
    parser do
      banner "myapp [options]+"
      opt 'pipeline.dir', :long => 'pipeline-dir', :short => 'd', :description => "The pipeline directory we are using", :cast => :string
      opt 'config.dir'  , :long => 'config-dir',   :short => 'c', :description => "The directory to load configuration from", :cast => :string
      opt 'timelimit'   , :long => 'time-limit',   :short => 't', :description => "The amount of time to run for", :cast => :integer
      opt 'system'      , :long => 'system',       :short => 's', :description => "The system setting", :cast => :string
      opt 'debug'       , :long => 'debug',        :short => 'D', :description => "Turn on debugging", :cast => :boolean
    end

    # This defines a MyApp::Application::Plan class. This class is also
    # available via MyApp::Application.plan
    plan do
      try MyApp::Application.parser
      try Yacl::Loader::Env, :prefix => 'MY_APP'
      try Yacl::Loader::YamlDir, :parameter => 'config.dir'
      try MyApp::Application.defaults

      on_error do |exception|
        $stderr.puts "ERROR: #{exception}"
        $stderr.puts "Try --help for help"
        exit 1
      end
    end

    # This is the method that will be run when it is executed on the
    # commandline.
    def run
      puts properties.map.inspect
    end
  end
end
