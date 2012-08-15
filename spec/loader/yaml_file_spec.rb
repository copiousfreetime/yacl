require 'spec_helper'

describe Yacl::Loader::YamlFile do
  before do
    @yaml_contents = <<_yml_
a: foo
b: bar
_yml_
    @tmpdir    = Dir.mktmpdir
    @yaml_file = File.join( @tmpdir, "ytest.yml" )
    SpecHelpers.tmpfile_with_contents( @yaml_file, @yaml_contents )

    @scoped_file = File.join( @tmpdir, "yscoped.yml" )
    SpecHelpers.tmpfile_with_contents( @scoped_file, <<_eob_ )
development:
  a: foo
  b: bar
production:
  a: baz
  b: wibble
_eob_

  
  end

  after do
    FileUtils.rm_rf( @tmpdir ) if @tmpdir
  end

  it "returns a config containing properties" do
    e = Yacl::Loader::YamlFile.new( @yaml_file )
    c = e.configuration
    c.a.must_equal 'foo'
    c.b.must_equal 'bar'
  end

  it "raises an error if the file does not exist" do
    lambda { Yacl::Loader::YamlFile.new( "/does/not/exist" ) }.must_raise Yacl::Loader::YamlFile::Error
  end

  it "raises an error if the file is not readable" do
    File.chmod( 0000, @yaml_file )
    lambda { Yacl::Loader::YamlFile.new( @yaml_file ) }.must_raise Yacl::Loader::YamlFile::Error
    File.chmod( 0400, @yaml_file )
  end

  it "raises an error if the file is not a top level hash" do
    bad_file = File.join( @tmpdir, "notahash.yml" )
    SpecHelpers.tmpfile_with_contents( bad_file, <<_eob_ )
- a: foo
- b: bar
_eob_
    lambda { Yacl::Loader::YamlFile.new( bad_file ) }.must_raise Yacl::Loader::YamlFile::Error
  end

  it "returns a scoped config containing properties" do
    e = Yacl::Loader::YamlFile.new( @scoped_file, "production" )
    c = e.configuration
    c.a.must_equal 'baz'
    c.b.must_equal 'wibble'
  end

  it "raises an error if the scoped config does not contain the scoped key" do
    lambda { Yacl::Loader::YamlFile.new( @scoped_file, "badscope" ) }.must_raise Yacl::Loader::YamlFile::Error
  end

end
