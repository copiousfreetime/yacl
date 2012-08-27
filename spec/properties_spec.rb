require 'spec_helper'
require 'yacl/properties'

describe 'Yacl::Properties' do
  it "can be initialized with a hash" do
    p = Yacl::Properties.new(  'a' => 'foo', 'b' => 'bar'  )
    p['a'].must_equal 'foo'
  end
end
