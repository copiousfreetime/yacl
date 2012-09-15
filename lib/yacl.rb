# Yacl is Your Application Configuration Library.
#
# See the README
module Yacl
  # The Current Version of the library
  VERSION = "0.0.1"
  class Error < ::StandardError; end
end
require 'yacl/properties'
require 'yacl/loader'
require 'yacl/define'
