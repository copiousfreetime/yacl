require 'spec_helper'
require 'yacl/define/defaults'

module Yacl::Spec::Define
  class DefaultsTest < ::Yacl::Define::Defaults
    default 'host.name', 'localhost'
    default 'host.port',  80
  end
end

describe Yacl::Define::Defaults do
  before do
    @dt = Yacl::Spec::Define::DefaultsTest.new
  end

  it "allows for instance level access to the defaults" do
    @dt.host.name.must_equal 'localhost'
    @dt.host.port.must_equal 80
  end

  #it "does not allow for the setting of default values" do
  #  lambda { @dt.set( 'host.foo', 'bar' ) }.must_raise Yacl::Define::Defaults::Error
  #end
end
