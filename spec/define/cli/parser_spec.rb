require 'yacl/define/cli/parser'

module Yacl::Spec::Define
  class OptionsForParserTest < ::Yacl::Define::Cli::Options
    opt 'pipeline.dir', :long => 'pipeline-dir', :short => 'd', :description => "The pipeline directory we are using"
    opt 'timelimit'   , :long => 'time-limit',   :short => 't', :description => "The amount of time to run for"
    opt 'system'      , :long => 'system',       :short => 's', :description => "The system setting"
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
    bt.banner.must_match /Usage.*Options:/m
  end

  it "can set a banner" do
    bt = Yacl::Spec::Define::ParserWithBannerTest.new
    bt.banner.must_equal 'MyApp version 4.2'
  end

end
