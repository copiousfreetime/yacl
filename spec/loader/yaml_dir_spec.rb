require 'spec_helper'

describe Yacl::Loader::YamlDir do
  before do
    @yaml_dir = Yacl::Spec::Helpers.spec_dir( 'data', 'yaml_dir' )
  end

  it "returns a config containing properties" do
    e = Yacl::Loader::YamlDir.new( :directory => @yaml_dir )
    c = e.properties
    c.httpserver.port.must_equal 4321
    c.database.username.must_equal "myusername"
    c.database.subpart.baz.must_equal 'wibble'
  end

  it "raises an error if the directory does not exist" do
    lambda { Yacl::Loader::YamlDir.new( :directory => "/does/not/exist" ).properites }.must_raise Yacl::Loader::YamlDir::Error
  end

end
