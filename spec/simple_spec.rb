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
      opt 'host.port', :long => 'port',      :short => 'p', :description => "The port to listen on", :cast => :int
      opt 'host.address', :long => 'address',   :short => 'a', :description => "The address to listen at", :cast => :string
      opt 'directory', :long => 'directory', :short => 'd', :description => "The directory to operate out of", :cast => :string
      opt 'log.level', :long => 'log-level', :short => 'l', :description => "The system setting", :cast => :string
    end

    argv = [ '--directory' , Dir.pwd, '--port' , "4321", '--address', 'localhost' ]
    p = klass.new( :argv => argv )
    p.banner.must_equal 'MySimpleApp version 4.2'
    props = p.properties
    props.directory.must_equal Dir.pwd
    props.host.port.must_equal 4321
    props.host.address.must_equal 'localhost'
  end
end
