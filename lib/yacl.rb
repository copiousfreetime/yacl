module Yacl
  # The Current Version of the library
  VERSION = "0.0.1"
  class Error < ::StandardError; end
end
require 'yacl/configuration'
require 'yacl/define/defaults'
require 'yacl/loader'
