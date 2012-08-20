module Yacl
  # The Current Version of the library
  VERSION = "0.0.1"
  class Error < ::StandardError; end
end
require 'yacl/configuration'
require 'yacl/set_defaults'
require 'yacl/loader'
