require 'spec_helper'
require 'yacl/simple'

class Yacl::Spec::Simple < Yacl::Simple

end

describe Yacl::Simple do

  it "#defaults creates a child class of Yacl::Define::Defaults" do
    dklass = Yacl::Simple.defaults do
      default 'host.name', 'localhost'
      default 'host.port',  80
    end
    d = dklass.new

    d.must_be_kind_of Yacl::Define::Defaults
    d.host.name.must_equal 'localhost'
    d.host.port.must_equal 80

  end

  it "#parser creates a child class of Yacl::Define::Parser" do
    klass = Yacl::Simple.parser do
      banner "MySimpleApp version 4.2"
      opt 'pipeline.dir', :long => 'pipeline-dir', :short => 'd', :description => "The pipeline directory we are using", :cast => :string
      opt 'timelimit'   , :long => 'time-limit',   :short => 't', :description => "The amount of time to run for", :cast => :int
      opt 'system'      , :long => 'system',       :short => 's', :description => "The system setting", :cast => :string
    end

    argv = [ '--pipeline-dir' , Dir.pwd, '--time-limit' , "42", '--system', 'out-of-this-world' ]
    p = klass.new( :argv => argv )
    p.banner.must_equal 'MySimpleApp version 4.2'
    props = p.properties
    props.pipeline.dir.must_equal Dir.pwd
    props.timelimit.must_equal 42
    props.system.must_equal 'out-of-this-world'
  end
end
