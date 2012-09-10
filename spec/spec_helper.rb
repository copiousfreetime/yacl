if RUBY_VERSION >= '1.9.2' then
  require 'simplecov'
  puts "Using coverage!"
  SimpleCov.start if ENV['COVERAGE']
end

gem 'minitest'
require 'yacl'
require 'minitest/autorun'
require 'minitest/pride'
require 'tmpdir'

module Yacl
  module Spec
    module Helpers
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
  end
end
