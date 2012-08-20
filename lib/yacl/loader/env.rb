module Yacl
  class Loader
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
      def initialize( env = ENV, prefix = nil )
        super()
        @env    = env
        @prefix = prefix
        @map    = load_config( @env, @prefix )
      end

      private

      # Given the input hash and a key prefix, load the hash into a the @map
      #
      def load_config( env, prefix )
        dot_env    = convert_to_dotted_keys( env )
        dot_prefix = to_property_path( prefix )
        key_map    = filter_keys( dot_env.keys, dot_prefix )
        m          = Map.new

        key_map.each do |orig_key, filtered_key|
          args = filtered_key.split(".")
          args << dot_env[orig_key].to_s
          m.set( *args )
        end
        return m
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

      # return a hash-like filteration of the input hash also normalizing keys
      # to the dotted notation
      def filter_keys( keys, prefix )
        regex    = %r{\A(.*)\Z}
        regex    = %r{\A#{prefix}\.(.*)\Z} if prefix
        selected = {}
        keys.each do |k|
          if data = regex.match( k ) then
            selected[k] = data.captures.first
          end
        end
        return selected
      end
    end
  end
end
