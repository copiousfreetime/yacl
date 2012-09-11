module Yacl::Define::Cli

  Option = Struct.new( :property_name, :long, :short, :description, :cast)

  class Options < ::Yacl::Loader

    # Internal:
    def self.opt_list
      @opt_list||= []
    end

    # Public
    def self.opt(name, p = {} )
      opt_list << Option.new( name, p[:long], p[:short], p[:description ], p[:cast] )
    end

    # Public
    def self.banner( *args )
      @banner = args.first unless args.empty?
      @banner ||= "Usage  :  #{File.basename($0)} [options]+\nOptions:"
    end

    # Public
    def properties
      load_properties( @options )
    end

    def banner
      self.class.banner
    end

    def each
      self.class.opt_list.each do |o|
        yield o
      end
    end

    private

    # Given the input hash and a key prefix, load the hash into a the @map
    #
    def load_properties( hash )
      prop_hash = {}
      opt_list.each do |o|
        next unless hash.has_key?( o.long )
        prop_hash[o.property_name] = hash[o.long]
      end
      return Yacl::Properties.new( prop_hash )
    end
  end
end
