require 'spec_helper'

describe Yacl::Loader::Env do
  it "returns a config containing properties" do
    env = { 'MY_APP_A' => 'foo', 'MY_APP_B' => 'bar' }
    e = Yacl::Loader::Env.new( :env => env, :prefix => "MY_APP" )
    p = e.properties
    p.a.must_equal 'foo'
    p.b.must_equal 'bar'
  end

  it "raises an error if no prefix is given" do
    env = { 'MY_APP_A' => 'foo', 'MY_APP_B' => 'bar', "SOMETHING_ELSE" => 'baz' }
    lambda { Yacl::Loader::Env.new( :env => env ) }.must_raise Yacl::Loader::Env::Error
  end

  it "uses only those keys with the given prefix and strips that prefix" do
    env = { 'MY_APP_A' => 'foo', 'MY_APP_B' => 'bar', "SOMETHING_ELSE" => 'baz' }
    e = Yacl::Loader::Env.new( :env => env, :prefix => "my.app" )
    p = e.properties
    p.a.must_equal 'foo'
    p.b.must_equal 'bar'
    p.has_key?('c').must_equal false
  end

  it "does okay if there are no keys" do
    env = { 'MY_APP_A' => 'foo', 'MY_APP_B' => 'bar', "SOMETHING_ELSE" => 'baz' }
    e = Yacl::Loader::Env.new( :env => env, :prefix => "WIBBLE_FOO_BAR" )
    p = e.properties
    p.has_key?('c').must_equal false
  end
end
