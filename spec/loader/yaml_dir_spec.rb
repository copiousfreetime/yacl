require 'spec_helper'

describe Yacl::Loader::YamlDir do
  before do
    @yaml_dir = SpecHelpers.spec_dir( 'data', 'yaml_dir' )
  end

  it "returns a config containing properties" do
    e = Yacl::Loader::YamlDir.new( @yaml_dir )
    c = e.configuration
    c.httpserver.port.must_equal 4321
    c.database.username.must_equal "myusername"
  end

  it "raises an error if the directory does not exist" do
    lambda { Yacl::Loader::YamlDir.new( "/does/not/exist" ) }.must_raise Yacl::Loader::YamlDir::Error
  end

end
