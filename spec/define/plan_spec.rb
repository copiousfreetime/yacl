require 'spec_helper'
require 'yacl/define/plan'

module Yacl::Spec::Define
  class OptionsForPlan < ::Yacl::Define::Cli::Options
    opt 'pipeline.dir', :long => 'pipeline-dir', :short => 'd', :description => "The pipeline directory we are using", :cast => :string
    opt 'timelimit'   , :long => 'time-limit',   :short => 't', :description => "The amount of time to run for", :cast => :int
    opt 'system'      , :long => 'system',       :short => 's', :description => "The system setting", :cast => :string
    opt 'config.dir'  , :long => 'config-dir'  , :short => 'c', :description => "The configuration directory we are using", :cast => :string
  end

  class ParserForPlan < ::Yacl::Define::Cli::Parser
    options OptionsForPlan
  end

  class DefaultsForPlan < ::Yacl::Define::Defaults
    default 'host.name', 'localhost'
    default 'host.port',  80
  end

  class Plan < ::Yacl::Define::Plan
    try ParserForPlan
    try Yacl::Loader::YamlDir, :parameter => 'config.dir'
    try DefaultsForPlan
  end


end

describe Yacl::Define::Plan do
  before do
    @config_dir = Yacl::Spec::Helpers.spec_dir( 'data/yaml_dir' )
    @argv = [ '--pipeline-dir' , Dir.pwd,
              '--time-limit' , "42",
              '--system', 'out-of-this-world',
              '--config-dir' , @config_dir
            ]
  end

  it "loads properties from the try locations" do
    p = Yacl::Spec::Define::Plan.new( :argv => @argv )
    props = p.properties
    props.host.name.must_equal 'localhost'
    props.host.port.must_equal 80
    props.system.must_equal 'out-of-this-world'
  end

  it "raises an error when there is an error in loading properties" do
    lambda { Yacl::Spec::Define::Plan.new }.must_raise Yacl::Loader::YamlDir::Error
  end

  it "raises an error if you call #on_error and one is not defined" do
    lambda { Yacl::Spec::Define::Plan.on_error }.must_raise ::Yacl::Define::Plan::Error
  end

  it "can define an on_error block" do
    class PlanWithErrorBlock < Yacl::Define::Plan
      class MyError < ::StandardError; end
      try Yacl::Loader::YamlDir, :parameter => 'config.dir'
      on_error do |exception|
        raise MyError, "KABOOM!"
      end
    end

    lambda { PlanWithErrorBlock.new }.must_raise PlanWithErrorBlock::MyError
  end

  it "can define an on_error callable" do
    class PlanWithErrorCallable < Yacl::Define::Plan
      class MyError < ::StandardError; end
      try Yacl::Loader::YamlDir, :parameter => 'config.dir'
      on_error Proc.new{ raise MyError, "from a proc!" }
    end
    lambda { PlanWithErrorCallable.new }.must_raise PlanWithErrorCallable::MyError
  end

end
