require 'spec_helper'

describe Yacl::Loader::Env do
  it "returns a config containing properties" do
    env = { 'MY_APP_A' => 'foo', 'MY_APP_B' => 'bar' }
    e = Yacl::Loader::Env.new( env )
    c = e.configuration
    c.my.app.a.must_equal 'foo'
    c.my.app.b.must_equal 'bar'
  end

  it "uses all keys when there is no prefix" do
    env = { 'MY_APP_A' => 'foo', 'MY_APP_B' => 'bar', "SOMETHING_ELSE" => 'baz' }
    e = Yacl::Loader::Env.new( env )
    c = e.configuration
    c.my.app.a.must_equal 'foo'
    c.my.app.b.must_equal 'bar'
    c.something.else.must_equal 'baz'
  end

  it "uses only those keys with the given prefix and strips that prefix" do
    env = { 'MY_APP_A' => 'foo', 'MY_APP_B' => 'bar', "SOMETHING_ELSE" => 'baz' }
    e = Yacl::Loader::Env.new( env, "my.app" )
    c = e.configuration
    c.a.must_equal 'foo'
    c.b.must_equal 'bar'
    c.c?.must_equal false
  end
end
