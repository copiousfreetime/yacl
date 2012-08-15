gem 'minitest'
require 'yacl'
require 'minitest/autorun'
require 'minitest/pride'
require 'tmpdir'

module SpecHelpers
  def self.tmpfile_with_contents( full_path, contents )
    File.open ( full_path, "w+" ) do |f|
      f.write( contents )
    end
  end
end
