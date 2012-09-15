require 'spec_helper'

describe Yacl::Loader::YamlDir do
  before do
    @yaml_dir = Yacl::Spec::Helpers.spec_dir( 'data', 'yaml_dir' )
  end

  it "returns a config containing properties" do
    e = Yacl::Loader::YamlDir.new( :path => @yaml_dir )
    c = e.properties
    c.httpserver.port.must_equal 4321
    c.database.username.must_equal "myusername"
    c.database.subpart.baz.must_equal 'wibble'
  end

  it "raises an error if the directory does not exist" do
    lambda { Yacl::Loader::YamlDir.new( :path => "/does/not/exist" ).properties }.must_raise Yacl::Loader::YamlDir::Error
  end

  it "can lookup the directory in the passed through configuration if it is not given" do
    cfg = Yacl::Properties.new( 'directory' => @yaml_dir )
    e = Yacl::Loader::YamlDir.new( :properties => cfg, :parameter  => 'directory' )
    c = e.properties
    c.httpserver.port.must_equal 4321
    c.database.username.must_equal "myusername"
    c.database.subpart.baz.must_equal 'wibble'
  end

  it "raises an error if no directory was given and it was unable to look it up in a configuration" do
    lambda { Yacl::Loader::YamlDir.new( :parameter => "directory" ).properties }.must_raise Yacl::Loader::YamlDir::Error
  end

  it "raises an error if no directory was given and it was unable to look it up in a configuration" do
    cfg = Yacl::Properties.new( 'directory' => @yaml_dir )
    lambda { Yacl::Loader::YamlDir.new( :properties => cfg ).properties }.must_raise Yacl::Loader::YamlDir::Error
  end

  it "raises an error if no directory was given and the value in the configuration doesn't exist" do
    cfg = Yacl::Properties.new( 'path' => @yaml_dir )
    lambda { Yacl::Loader::YamlDir.new( :properties => cfg, :parameter => 'my.path' ).properties }.must_raise Yacl::Loader::YamlDir::Error
  end

end
