require 'spec_helper'

class Yacl::Spec::DefaultsTest
  include Yacl::SetDefaults

  default 'host.name', 'localhost'
  default 'host.port',  80
end

describe Yacl::SetDefaults do
  before do
    @dt = Yacl::Spec::DefaultsTest.new
  end
  it "allows for class level access to the defaults" do
    Yacl::Spec::DefaultsTest.host.name.must_equal 'localhost'
    Yacl::Spec::DefaultsTest.host.port.must_equal 80
  end

  it "allows for instance level access to the defaults" do
    @dt.host.name.must_equal 'localhost'
    @dt.host.port.must_equal 80
  end

  #it "does not allow for the setting of default values" do
  #  lambda { @dt.set( 'host.foo', 'bar' ) }.must_raise Yacl::SetDefaults::Error
  #end
end
