require 'forwardable'
require 'set'
require 'map'

module Yacl
  # Properties is a wrapper around keys and values that are part of a
  # Configuration. This is just the keys and the values, it does not tie it to
  # where the data comes from.
  #
  # The properties interface is a limited subset of the Hash interface.
  #
  # Properties may also be accessed via a dotted method call location
  #
  # Example:
  #
  #   p = Properties.new(  'my.a' => 'foo', 'my.b' => 'bar' )
  #   p.my.a #=> 'foo'
  #   p.my.b #=> 'bar'
  #   p.my   #=> Properties
  #
  #
  class Properties
    extend Forwardable

    # Internal: returns the list of methods to delegate to the internal Map
    # instance
    #
    # Returns an Array of method names
    def self.delegating_to_map
      [ :set, :get, :fetch, :store, :delete, :clear, :[], :[]=, :has?, :has_key?, :each, :length, :keys, :method_missing ]
    end

    # Internal: Returns the list of methods that may be delegated to a
    # Properties instance.
    #
    # Returns an Array of method names
    def self.delegatable_methods
      delegating_to_map + [ :scoped_by, :scopes, :has_scope? ]
    end

    # Internal: Delegate methods to the internal Map instance
    def_delegators :@map, *Properties.delegating_to_map

    # Internal: used only for merging
    #
    # Returns the internal Map instances
    attr_reader :map

    # Create a new Properites
    #
    # initial - A Hash or Map that is used as the initial values of the
    #           Properites
    #
    def initialize( initial = {} )
      @map = Map.new
      expanded_keys( initial ) do |k,v|
        k << v
        @map.set( *k )
      end
    end

    # Public: Mereg another Properties instance on top of this one, overwriting
    # any commaon key/values.
    #
    # This is a destructive operation on this Properties instance.
    #
    # other - The Properties instance to lay on top of this one.
    #
    # Returns nothing
    def merge!( other )
      @map.merge!( other.map )
    end

    # Public: Return a new Properties that is a subset of the properties with the first
    # prefix removed.
    #
    # scope - the scope under which to use
    #
    # Returns a new Properties object
    def scoped_by( *scope )
      scope = scope.length == 1 ? scope.first : scope
      sub_map = @map.get( expand_key( scope ) ) || {}
      Properties.new( sub_map )
    end

    # Public: List the knownn scops, i.e. top level keys, of the current
    # Properitess.
    #
    # Returns an Array
    def scopes
      scope_names.to_a.sort
    end

    # Public: Return true or false if the Properites instance has the given
    # scope.
    #
    # Returns true or false.
    def has_scope?( scope )
      scope_names.include?( scope )
    end

    private

    # Internal: The list of all scope names
    #
    # Returns an Array of Strings
    def scope_names
      keys.map { |k| k.to_s }
    end

    # Internal: Expand the hash into an Array including the multi-value key and
    # the value.
    #
    # hash - the Hash to convert to an array of arrays.
    #
    # Yields the Array of the currenty key and the value
    #
    # Returns nothing.
    def expanded_keys( hash )
      hash.each do |k,v|
        ek = expand_key( k )
        yield ek, v unless ek.empty?
      end
    end

    # Internal: Convert the given key into an Array key suitable for use with
    # Map.set
    #
    # key - the Key
    #
    # Retursn an Array
    def expand_key( key )
      ek = case key
      when Array
        key
      when /\./
        key.split(".")
      else
        [ key ]
      end
      ek.select { |k| k.to_s.strip.length > 0 }
    end
  end
end
