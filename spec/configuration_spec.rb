require 'spec_helper'
require 'yacl/configuration'

module Yacl::Spec::Define
  class ConfigurationDefaults < ::Yacl::Define::Defaults
    default 'my.a', 'foo'
    default 'my.b', 'bar'
    default 'other.c', 'baz'
    default 'other.deep.foo', 'wibble'
  end
end

describe 'Yacl::Configuration' do
  before do
    @configuration = Yacl::Configuration.new( Yacl::Spec::Define::ConfigurationDefaults.new )
  end

  it "can access values with a dot notiation" do
    @configuration.my.b.must_equal 'bar'
  end

  it "can be scoped by a prefix" do
    s = @configuration.scoped_by( 'my' )
    s['a'].must_equal 'foo'
    s.a.must_equal 'foo'
    s['b'].must_equal 'bar'
    s.b.must_equal 'bar'
    s.has_key?( 'c' ).must_equal false
    s.c?.must_equal false
  end

  it "can say what its scopes are" do
    @configuration.scopes.must_equal %w[ my other ]
  end

  it "can say that it has a given scope" do
    @configuration.has_scope?( 'my' ).must_equal true
  end

  it "can scope to multiple levels via dotted notation" do
    s = @configuration.scoped_by('other.deep')
    s.foo.must_equal 'wibble'
  end

  it "can scope to multiple levels via args notation" do
    s = @configuration.scoped_by(:other, :deep)
    s.foo.must_equal 'wibble'
  end

  it "can say that it does not have a scope" do
    @configuration.has_scope?( 'your' ).must_equal false
  end
end
