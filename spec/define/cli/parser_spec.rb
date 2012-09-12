require 'yacl/define/cli/parser'

module Yacl::Spec::Define
  class OptionsForParserTest < ::Yacl::Define::Cli::Options
    opt 'pipeline.dir', :long => 'pipeline-dir', :short => 'd', :description => "The pipeline directory we are using", :cast => :string
    opt 'timelimit'   , :long => 'time-limit',   :short => 't', :description => "The amount of time to run for", :cast => :int
    opt 'system'      , :long => 'system',       :short => 's', :description => "The system setting", :cast => :string
  end

  class ParserTest < ::Yacl::Define::Cli::Parser
    options OptionsForParserTest
  end

  class ParserWithBannerTest < ::Yacl::Define::Cli::Parser
    banner "MyApp version 4.2"
    options OptionsForParserTest
  end

end

describe Yacl::Define::Cli::Parser do

  it "has a default banner" do
    bt = Yacl::Spec::Define::ParserTest.new
    bt.banner.must_match( /Usage.*Options:/m )
  end

  it "can set a banner" do
    bt = Yacl::Spec::Define::ParserWithBannerTest.new
    bt.banner.must_equal 'MyApp version 4.2'
  end

  it "can set the options class" do
    Yacl::Spec::Define::ParserTest.options.must_equal Yacl::Spec::Define::OptionsForParserTest
  end

  it "creates a Properties instance from parsing the commandline" do
    argv = [ '--pipeline-dir' , Dir.pwd, '--time-limit' , "42", '--system', 'out-of-this-world' ]
    p = Yacl::Spec::Define::ParserTest.new( :argv => argv )
    props = p.properties
    props.pipeline.dir.must_equal Dir.pwd
    props.timelimit.must_equal 42
    props.system.must_equal 'out-of-this-world'
  end

end
