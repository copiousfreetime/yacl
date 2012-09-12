require 'spec_helper'
require 'yacl/define/cli/runner'

module Yacl::Spec::Define::Cli
  class OptionsForRunner < ::Yacl::Define::Cli::Options
    opt 'pipeline.dir', :long => 'pipeline-dir', :short => 'd', :description => "The pipeline directory we are using", :cast => :string
    opt 'timelimit'   , :long => 'time-limit',   :short => 't', :description => "The amount of time to run for", :cast => :int
    opt 'system'      , :long => 'system',       :short => 's', :description => "The system setting", :cast => :string
    opt 'config.dir'  , :long => 'config-dir'  , :short => 'c', :description => "The configuration directory we are using", :cast => :string
  end

  class ParserForRunner < ::Yacl::Define::Cli::Parser
    options OptionsForRunner
  end

  class DefaultsForRunner < ::Yacl::Define::Defaults
    default 'host.name', 'localhost'
    default 'host.port',  80
  end

  class PlanForRunner < ::Yacl::Define::Plan
    try ParserForRunner
    try DefaultsForRunner
  end

  class Runner < ::Yacl::Define::Cli::Runner
    plan PlanForRunner

    def run
      42
    end

  end


end

describe Yacl::Define::Cli::Runner do

  it "raises an error if no plan is defined" do
    class BadRunner < ::Yacl::Define::Cli::Runner
      plan nil
    end

    lambda { BadRunner.go }.must_raise ::Yacl::Define::Cli::Runner::Error
  end

  it "executes the run method defined in the Runner child class" do
    r = Yacl::Spec::Define::Cli::Runner.go
    r.must_equal 42
  end

  it "loads the propertes in the plan into the runner" do
    r = Yacl::Spec::Define::Cli::Runner.new
    r.properties.host.port.must_equal 80
  end
end
