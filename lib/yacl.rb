# Yacl is Your Application Configuration Library.
#
# See the README
module Yacl
  # The Current Version of the library
  VERSION = "1.0.0"
  class Error < ::StandardError; end
end
require 'yacl/properties'
require 'yacl/loader'
require 'yacl/define'
require 'yacl/simple'
