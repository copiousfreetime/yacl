require 'xmlsimple'
require 'pathname'

class Yacl::Loader
  class XmlFile
    class Error < ::Yacl::Loader::Error; end

    class CasedString
      def initialize(string)
        @string = string
      end

      def underscore
        @string.gsub(/(.)([A-Z])/, '\1_\2').downcase
      end

      def camelize
        @string.gsub(/_[a-z]/) { |m| m[-1..-1].upcase }
      end
    end

    def initialize(options = options)
      @options = options
    end

    def properties
      validate_file

      properties = Yacl::Properties.new

      scoped_attributes.each do |key, values|
        underscored_key = CasedString.new(key).underscore
        properties[underscored_key] = values.first
      end

      properties
    end

    private

    def scoped_attributes
      return raw_attributes if @options[:scope].nil?

      camelized_scope = CasedString.new(@options[:scope]).camelize
      scoped_attributes = raw_attributes[camelized_scope]

      if scoped_attributes.nil?
        raise Error, "'#{@options[:scope]}' scope does not exist"
      else
        scoped_attributes.first
      end
    end

    def raw_attributes
      XmlSimple.xml_in(path.read)
    rescue REXML::ParseException, ArgumentError
      raise Error.new(REXML::ParseException)
    end

    def validate_file
      raise Error, "#{path} does not exists" unless path.exist?
      raise Error, "#{path} is not readable" unless path.readable?
    end

    def path
      raise Error, "A path must be provided" unless @options[:path]
      Pathname.new(@options[:path])
    end
  end
end