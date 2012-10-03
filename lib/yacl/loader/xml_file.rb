require 'rexml/document'
require 'pathname'

class Yacl::Loader
  class XmlFile < ::Yacl::Loader::LoadableFile
    class Error < ::Yacl::Loader::Error; end

    def properties
      validate_and_load_properties( @path, @scope )
    end

    private

    def load_properties( path, scope )
      properties = Yacl::Properties.new

      elements( path, scope ).each do |element|
        key   = underscore(element.name)
        value = element.texts.join

        properties.set( key, value )
      end

      properties
    end

    def elements( path, scope )
      root = root_element( path )
      if scope.nil? then
        root.elements
      else
        scoped_elements( root, scope )
      end
    end

    def scoped_elements( root, scope )
      scoped_element = root.elements[ camelize( scope ) ]
      raise Error, "'#{scope}' scope does not exist" unless scoped_element
      scoped_element.elements
    end

    def root_element( path )
      root = REXML::Document.new( path.read ).root
      raise Error, "Not a valid XmlFile" unless root
      return root
    rescue REXML::ParseException
      raise Error.new(REXML::ParseException)
    end

    def underscore( s )
      s.gsub(/(.)([A-Z])/, '\1_\2').downcase
    end

    def camelize( s )
      s.gsub(/_[a-z]/) { |m| m[-1..-1].upcase }
    end
  end
end
