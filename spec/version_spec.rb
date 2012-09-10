require 'spec_helper'

describe 'Yacl::VERSION' do
  it 'should have a #.#.# format' do
    Yacl::VERSION.must_match( /\A\d+\.\d+\.\d+\Z/ )
    Yacl::VERSION.to_s.must_match( /\A\d+\.\d+\.\d+\Z/ )
  end
end
