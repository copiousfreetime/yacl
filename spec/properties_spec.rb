require 'spec_helper'
require 'yacl/properties'

describe 'Yacl::Properties' do
  before do
    @properties = Yacl::Properties.new(  'my.a' => 'foo', 'my.b' => 'bar', 'other.c' => 'baz' )
  end
  it "can be initialized with a hash" do
    p = Yacl::Properties.new(  'a' => 'foo', 'b' => 'bar'  )
    p['a'].must_equal 'foo'
    p.a.must_equal 'foo'
  end

  it "can access values with a dot notiation" do
    @properties.my.b.must_equal 'bar'
  end

  it "can be scoped by a prefix" do
    s = @properties.scoped_by( 'my' )
    s['a'].must_equal 'foo'
    s['b'].must_equal 'bar'
    s.has_key?( 'c' ).must_equal false
  end

  it "can say what its scopes are" do
    @properties.scopes.must_equal %w[ my other ]
  end

  it "can say that it has a given scope" do
    @properties.has_scope?( 'my' ).must_equal true
  end

  it "can say that it does not have a scope" do
    @properties.has_scope?( 'your' ).must_equal false
  end
end
