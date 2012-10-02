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

    it "raises an error if no path or a nil path is given" do
      lambda { XmlFile.new( {} ).properties }.must_raise XmlFile::Error
      lambda { XmlFile.new( { :path => nil } ).properties }.must_raise XmlFile::Error
    end

    it "raises an error if the file does not exist" do
      lambda { XmlFile.new( :path => "/does/not/exist" ).properties }.must_raise XmlFile::Error
    end

    it "raises an error if the file is not readable" do
      path = make_file
      File.chmod(000, path)
      lambda { XmlFile.new( :path => path ).properties }.must_raise XmlFile::Error
    end

    it "raises an error if the file is not well formed xml" do
      lambda { XmlFile.new( :path => make_file("<bad>") ).properties }.must_raise XmlFile::Error
    end

    it "raises an error if the body contains super badly formed xml" do
      lambda { XmlFile.new( :path => make_file("realBad>") ).properties }.must_raise XmlFile::Error
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

    it "raises an error if the scope is not present" do
      xml = make_file("<config></config>")
      xml_file = XmlFile.new(:path => make_file(xml), :scope => "development")

      lambda { xml_file.properties }.must_raise XmlFile::Error
    end


  end
end