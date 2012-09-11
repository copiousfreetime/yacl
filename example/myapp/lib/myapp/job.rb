require 'myapp/defaults'
module MyApp
  module Job
    class Plan < Yacl::Define::Plan
      try Yacl::Loader::Env, :prefix => 'MY_APP'
      try Yacl::Loader::YamlDir, :directory => File.expand_path( "../../../config", __FILE__ )
      try MyApp::Defaults
      on_error do |exception|
        $stderr.puts exception
        $stderr.puts exception.backtrace.join("\n")
      end
    end

    class ForSomething
      def initialize( params )
        p = Yacl::Properties.new( params )
        plan = Job::Plan.new( :initial_properties => p )
        puts plan.properties.map.inspect
      end
    end
  end
end


