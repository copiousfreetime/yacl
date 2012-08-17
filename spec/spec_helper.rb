gem 'minitest'
require 'yacl'
require 'minitest/autorun'
require 'minitest/pride'
require 'tmpdir'

module SpecHelpers
  def self.tmpfile_with_contents( full_path, contents )
    File.open( full_path, "w+" ) do |f|
      f.write( contents )
    end
  end

  def self.spec_dir( *other )
    ::File.join( proj_root, 'spec', other )
  end

  def self.proj_root
    ::File.expand_path( "../../", __FILE__)
  end
end
