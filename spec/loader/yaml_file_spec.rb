require 'spec_helper'

describe Yacl::Loader::YamlFile do
  before do
    @yaml_contents = <<_yml_
a: foo
b: bar
_yml_
    @tmpdir    = Dir.mktmpdir
    @yaml_file = File.join( @tmpdir, "ytest.yml" )
    Yacl::Spec::Helpers.tmpfile_with_contents( @yaml_file, @yaml_contents )

    @scoped_file = File.join( @tmpdir, "yscoped.yml" )
    Yacl::Spec::Helpers.tmpfile_with_contents( @scoped_file, <<_eob_ )
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
    e = Yacl::Loader::YamlFile.new( :path => @yaml_file )
    p = e.properties
    p['a'].must_equal 'foo'
    p.a.must_equal 'foo'
    p['b'].must_equal 'bar'
    p.b.must_equal 'bar'
  end

  it "can lookup the file in the passed through configuration if it is not given" do
    cfg = Yacl::Properties.new( 'filename' => @yaml_file )
    e = Yacl::Loader::YamlFile.new( :properties => cfg, :parameter  => 'filename' )
    p = e.properties
    p.a.must_equal 'foo'
    p.b.must_equal 'bar'
  end


  it "raises an error if the file does not exist" do
    lambda { Yacl::Loader::YamlFile.new( :path => "/does/not/exist" ).properties }.must_raise Yacl::Loader::YamlFile::Error
  end

  it "raises an error if the file is not readable" do
    File.chmod( 0000, @yaml_file )
    lambda { Yacl::Loader::YamlFile.new( :path => @yaml_file ).properties }.must_raise Yacl::Loader::YamlFile::Error
    File.chmod( 0400, @yaml_file )
  end

  it "raises an error if the file is not a top level hash" do
    bad_file = File.join( @tmpdir, "notahash.yml" )
    Yacl::Spec::Helpers.tmpfile_with_contents( bad_file, <<_eob_ )
- a: foo
- b: bar
_eob_
    lambda { Yacl::Loader::YamlFile.new( :path => bad_file ).properties }.must_raise Yacl::Loader::YamlFile::Error
  end

  it "returns a scoped config containing properties" do
    e = Yacl::Loader::YamlFile.new( :path => @scoped_file, :scope => "production" )
    p = e.properties
    p['a'].must_equal 'baz'
    p.a.must_equal 'baz'
    p['b'].must_equal 'wibble'
    p.b.must_equal 'wibble'
  end

  it "raises an error if the scoped config does not contain the scoped key" do
    lambda { Yacl::Loader::YamlFile.new( :path => @scoped_file, :scope => "badscope" ).properties }.must_raise Yacl::Loader::YamlFile::Error
  end

end
