require 'spec_helper'
require 'yacl/simple'

class Yacl::Spec::Simple < Yacl::Simple

  defaults do
    default 'host.name', 'localhost'
    default 'host.port',  80
 end

  parser do
    banner "MySimpleApp version 4.2"
    opt 'host.port', :long => 'port',      :short => 'p', :description => "The port to listen on", :cast => :int
    opt 'host.bind', :long => 'address',   :short => 'a', :description => "The address to listen at", :cast => :string
    opt 'config.dir', :long => 'config',   :short => 'c', :description => "The configuration directory", :cast => :string
    opt 'log.level', :long => 'log-level', :short => 'l', :description => "The system setting", :cast => :string
  end

  plan do
    try Yacl::Spec::Simple.parser
    try Yacl::Loader::Env, :prefix => 'MY_APP'
    try Yacl::Loader::YamlDir, :parameter => 'config.dir'
    try Yacl::Spec::Simple.defaults

    on_error do |exception|
      $stderr.puts "ERROR: #{exception}"
      $stderr.puts "Try --help for help"
    end
  end

  def run
    properties
  end

end

describe Yacl::Simple do

  it "#defaults creates a child class of Yacl::Define::Defaults" do
    dklass = Yacl::Simple.defaults do
      default 'host.bind', 'localhost'
      default 'host.port',  80
      default 'config.dir', '/tmp'
      default 'log.level', 'error'
    end
    d = dklass.new

    d.must_be_kind_of Yacl::Define::Defaults
    d.host.bind.must_equal 'localhost'
    d.host.port.must_equal 80

  end

  it "#parser creates a child class of Yacl::Define::Parser" do
    klass = Yacl::Simple.parser do
      banner "MySimpleApp version 4.2"
      opt 'host.port', :long => 'port',      :short => 'p', :description => "The port to listen on", :cast => :int
      opt 'host.bind', :long => 'address',   :short => 'a', :description => "The address to listen at", :cast => :string
      opt 'directory', :long => 'directory', :short => 'd', :description => "The directory to operate out of", :cast => :string
      opt 'log.level', :long => 'log-level', :short => 'l', :description => "The system setting", :cast => :string
    end

    argv = [ '--directory' , Dir.pwd, '--port' , "4321", '--address', 'localhost' ]
    p = klass.new( :argv => argv )
    p.banner.must_equal 'MySimpleApp version 4.2'
    props = p.properties
    props.directory.must_equal Dir.pwd
    props.host.port.must_equal 4321
    props.host.bind.must_equal 'localhost'
  end

  it "can define a full plan" do
    config_dir = File.join( Yacl::Spec::Helpers.proj_root, 'example/myapp-simple/config' )
    argv = [ '--config' , config_dir , '--log-level', 'info' ]
    simple = Yacl::Spec::Simple.go( argv )
    simple.host.port.must_equal 4321
  end

  it "can use the on_error exception" do
    out, err = capture_io do
      Yacl::Spec::Simple.go
    end
    err.must_match( /Try --help for help/m )
  end
end
