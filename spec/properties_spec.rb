require 'spec_helper'
require 'yacl/properties'

describe 'Yacl::Properties' do
  it "can be initialized with a hash" do
    p = Yacl::Properties.new(  'a' => 'foo', 'b' => 'bar'  )
    p['a'].must_equal 'foo'
  end

  it "can be scoped by a prefix" do
    p = Yacl::Properties.new(  'my.a' => 'foo', 'my.b' => 'bar', 'other.c' => 'baz' )
    s = p.scoped_by( 'my' )
    s['a'].must_equal 'foo'
    s['b'].must_equal 'bar'
    s.has_key?( 'c' ).must_equal false
  end
end
