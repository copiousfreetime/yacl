require 'myapp/configuration'
module MyApp
  module Cli
    class Runner < ::Yacl::Define::Cli::Runner
      configuration MyApp::Configuration

      def run
        p = configuration.properties
        puts p.map.inspect
      end
    end
  end
end
