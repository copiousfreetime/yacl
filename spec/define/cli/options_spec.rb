require 'spec_helper'
require 'yacl/define/cli/options'

module Yacl::Spec::Define
  class OptionsTest < ::Yacl::Define::Cli::Options
    opt 'pipeline.dir', :long => 'pipeline-dir', :short => 'd', :description => "The pipeline directory we are using"
    opt 'timelimit'   , :long => 'time-limit',   :short => 't', :description => "The amount of time to run for"
    opt 'system'      , :long => 'system',       :short => 's', :description => "The system setting"
  end

  #class OptionsWithBannerTest < OptionsTest
    #banner "MyApp version 4.2"
  #end
end



describe Yacl::Define::Cli::Options do

  it "has all the options listed in the class" do
    Yacl::Spec::Define::OptionsTest.opt_list.size.must_equal 3
  end

  it "keeps the options in listed order" do
    Yacl::Spec::Define::OptionsTest.opt_list.map { |o| o.property_name }.must_equal  %w[ pipeline.dir timelimit system ]
  end

  it "implements each" do
    ot = Yacl::Spec::Define::OptionsTest.new
    gather = []
    ot.each do |op|
      gather << op.property_name
    end
    gather.must_equal %w[ pipeline.dir timelimit system ]

  end

  it "returns the properties of the options" do
    ot = Yacl::Spec::Define::OptionsTest.new( 'pipeline-dir' => "/var/log/", "time-limit" => 40, "system" => "foo" )
    props = ot.properties
    props.pipeline.dir.must_equal '/var/log/'
    props.timelimit.must_equal 40
    props.system.must_equal 'foo'
  end

end

