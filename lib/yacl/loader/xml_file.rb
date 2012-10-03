require 'rexml/document'
require 'pathname'

class Yacl::Loader
  class XmlFile < ::Yacl::Loader
    class Error < ::Yacl::Loader::Error; end

    def properties
      validate_file

      properties = Yacl::Properties.new

      scoped_attributes.each do |element|
        key   = underscore(element.name)
        value = element.texts.join

        properties.set( key, value )
      end

      properties
    end

    private

    def scoped_attributes
      root = document.root
      raise Error, "Not a valid XmlFile" unless root
      return root.elements if @options[:scope].nil?

      camelized_scope = camelize(@options[:scope])

      scoped_element = root.elements[ camelized_scope ]
      raise Error, "'#{@options[:scope]}' scope does not exist" unless scoped_element
      return scoped_element.elements
    end

    def document
      REXML::Document.new( path.read )
    rescue REXML::ParseException
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

    def underscore( s )
      s.gsub(/(.)([A-Z])/, '\1_\2').downcase
    end

    def camelize( s )
      s.gsub(/_[a-z]/) { |m| m[-1..-1].upcase }
    end
  end
end
