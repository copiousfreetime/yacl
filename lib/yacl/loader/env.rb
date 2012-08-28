class Yacl::Loader
  # Env loads a Configuration object from a hash, generally this would be ENV.
  #
  # The keys in the hash may be filtered by a prefix. For instance if you had
  # keys in the hash of :
  #
  #   MY_APP_OPTION_A
  #   MY_APP_OPTION_B
  #
  # And you wanted to have those loaded so they were accessible as
  # option.a and option.b you would use Loader::Env like:
  #
  #   config = Yacl::Loader::Env.new( ENV, 'MY_APP' ).config
  #
  class Env < ::Yacl::Loader
    def initialize( opts = {} )
      super
      @env    = @options.fetch( :env, ENV )
      @prefix = @options.fetch( :prefix, nil )
    end

    def properties
      load_properties( @env, @prefix )
    end

    private

    # Given the input hash and a key prefix, load the hash into a the @map
    #
    def load_properties( env, prefix )
      dot_env    = convert_to_dotted_keys( env )
      dot_prefix = to_property_path( prefix )
      p          = Yacl::Properties.new( dot_env )
      p          = p.scoped_by( dot_prefix ) if dot_prefix
      return p
    end

    def convert_to_dotted_keys( hash )
      converted = {}
      hash.each do |k,v|
        dot_k = to_property_path( k )
        converted[dot_k] = v
      end
      return converted
    end

    def to_property_path( name )
      return nil unless name
      name.downcase.gsub('_','.')
    end
  end
end
