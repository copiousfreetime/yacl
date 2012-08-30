require 'spec_helper'
require 'yacl/loader'

describe 'Yacl::Loader' do
  before do
    @loader = Yacl::Loader.new( :foo => 'bar', :baz => 'wibble' )
  end
  it "is initialized with options" do
    @loader.options[:foo].must_equal 'bar'
  end

  it "returns a Properties instance" do
    p = @loader.properties
    p.length.must_equal 0
  end
end
