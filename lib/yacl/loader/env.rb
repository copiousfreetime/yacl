class Yacl::Loader
  # Env loads a Configuration object from a hash, generally this would be ENV.
  #
  # The keys in the hash may be filtered by a prefix. For instance if you had
  # keys in the hash of :
  #
  #   MY_APP_OPTION_A => 'foo'
  #   MY_APP_OPTION_B => 'bar'
  #
  # And you wanted to have those loaded so they were accessible as
  # option.a and option.b you would use Loader::Env like:
  #
  # Example:
  #
  #   properties = Yacl::Loader::Env.new( ENV, 'MY_APP' ).properties
  #   properties.option.a # => 'foo'
  #   properties.option.b # => 'bar'
  #
  class Env < ::Yacl::Loader
    class Error < ::Yacl::Loader::Error; end

    # Create a new Env instance from the loaded options
    #
    # opts - a hash of options:
    #        :env => The environment has to pass in (default: ENV). required.
    #        :prefix => the prefix to strip off of each key in the :env hash. required.
    #
    def initialize( opts = {} )
      super
      @env    = @options.fetch( :env, ENV )
      @prefix = @options.fetch( :prefix, nil )
      raise Error, "No environment variable prefix is given" unless @prefix
    end

    # Public: return the Properties that are created from the environment hash.
    #
    # Returns a Properties instance
    def properties
      load_properties( @env, @prefix )
    end

    private

    # Internal: given a hash, and a key prefix, convert the hash into a
    # Properties instance.
    #
    # env    - a Hash of environment variables
    # prefix - a String of indicated the prefix of keys in env that are to be
    #          stripped off
    def load_properties( env, prefix )
      dot_env     = convert_to_dotted_keys( env )
      dot_prefix  = to_property_path( prefix )
      prefix_only = prefix_keys_only( dot_prefix, dot_env )
      p           = Yacl::Properties.new( prefix_only )
      p           = p.scoped_by( dot_prefix ) if dot_prefix
      return p
    end

    # Internal: Return a new Hash that has only those key/values where the key
    # is prefixed with the given prefix item.
    #
    # prefix - a string to compare against the keys of the hash
    # hash   - the hash to return a subset from
    #
    # Returns a Hash.
    def prefix_keys_only( prefix, hash)
      only = {}
      hash.each do |k,v|
        only[k] = v if k =~ /#{prefix}/
      end
      return only
    end

    # Internal: Take the input Hash, convert all the keys to a dotted notation
    # and return the new hash.
    #
    # The returnd hash will have keys that have been converted using
    # #to_property_path
    #
    # hash - the hash to convert
    #
    # Returns a hash.
    def convert_to_dotted_keys( hash )
      converted = {}
      hash.each do |k,v|
        dot_k = to_property_path( k )
        converted[dot_k] = v
      end
      return converted
    end

    # Internal: Convert the input String to a property style. The String is
    # downcased and all _ are converted to .
    #
    # name - the String to convert
    #
    # Returns the converted String.
    def to_property_path( name )
      return nil unless name
      name.downcase.gsub('_','.')
    end
  end
end
