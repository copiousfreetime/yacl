require 'spec_helper'

describe Yacl::Loader::Env do
  it "returns a config containing properties" do
    env = { 'MY_APP_A' => 'foo', 'MY_APP_B' => 'bar' }
    e = Yacl::Loader::Env.new( :env => env )
    p = e.properties
    p['my.app.a'].must_equal 'foo'
    p['my.app.b'].must_equal 'bar'
  end

  it "uses all keys when there is no prefix" do
    env = { 'MY_APP_A' => 'foo', 'MY_APP_B' => 'bar', "SOMETHING_ELSE" => 'baz' }
    e = Yacl::Loader::Env.new( :env => env )
    p = e.properties
    p['my.app.a'].must_equal 'foo'
    p['my.app.b'].must_equal 'bar'
    p['something.else'].must_equal 'baz'
  end

  it "uses only those keys with the given prefix and strips that prefix" do
    env = { 'MY_APP_A' => 'foo', 'MY_APP_B' => 'bar', "SOMETHING_ELSE" => 'baz' }
    e = Yacl::Loader::Env.new( :env => env, :prefix => "my.app" )
    p = e.properties
    p['a'].must_equal 'foo'
    p['b'].must_equal 'bar'
    p.has_key?('c').must_equal false
  end
end
