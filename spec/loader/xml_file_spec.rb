require 'tempfile'

class Yacl::Loader
  describe XmlFile do
    def make_file(contents="")
      file = Tempfile.new("xml_config")
      file.write(contents)
      file.close
      file.path
    end

    it "returns a config containing properties" do
      path = make_file("<config><thing>Stuff</thing></config>")

      xml_file = XmlFile.new(:path => path)
      xml_file.properties.thing.must_equal "Stuff"
    end

    it "converts camel case to underscore" do
      path = make_file("<config><daBears>Stuff</daBears></config>")

      xml_file = XmlFile.new(:path => path)
      xml_file.properties.da_bears.must_equal "Stuff"
    end

    it "raises an error if an empty path is given" do
      lambda { XmlFile.new( ).properties }.must_raise LoadableFile::Error
    end

    it "raises and error if a nil path is given" do
      lambda { XmlFile.new( { :path => nil } ).properties }.must_raise LoadableFile::Error
    end

    it "raises an error if the file does not exist" do
      lambda { XmlFile.new( :path => "/does/not/exist" ).properties }.must_raise LoadableFile::Error
    end

    it "raises an error if the file is not readable" do
      path = make_file
      File.chmod(000, path)
      lambda { XmlFile.new( :path => path ).properties }.must_raise LoadableFile::Error
    end

    it "raises an error if the file is not well formed xml" do
      lambda { XmlFile.new( :path => make_file("<bad>") ).properties }.must_raise XmlFile::Error
    end

    it "raises an error if the body is not xml at all" do
      lambda { XmlFile.new( :path => make_file("This is not xml") ).properties }.must_raise XmlFile::Error
    end

    it "returns a scoped config returning properties" do
      scoped_xml = "<config>
        <development>
          <thing>stuff</thing>
        </development>
      </config>"

      xml_file = XmlFile.new(:path => make_file(scoped_xml), :scope => "development")
      xml_file.properties.thing.must_equal "stuff"
    end

    it "camel cases the scope" do
      scoped_xml = "<config>
        <stagingEnv>
          <thing>stuff</thing>
        </stagingEnv>
      </config>"

      xml_file = XmlFile.new(:path => make_file(scoped_xml), :scope => "staging_env")
      xml_file.properties.thing.must_equal "stuff"
    end

    it "returns an empty properties if there are no items in the xml file" do
      xml = make_file("<config />")
      xml_file = XmlFile.new( :path => xml )
      xml_file.properties.length.must_equal 0
    end

    it "raises an error if the scope is not preesent in an empty xml file" do
      xml = make_file("<config />")
      xml_file = XmlFile.new( :path => xml, :scope => "staging" )
      lambda { xml_file.properties }.must_raise XmlFile::Error
    end

    it "raises an error if the scope is not present" do
      scoped_xml = "<config>
        <development>
          <thing>stuff</thing>
        </development>
      </config>"

      xml_file = XmlFile.new(:path => make_file(scoped_xml), :scope => "staging")

      lambda { xml_file.properties }.must_raise XmlFile::Error
    end


  end
end
