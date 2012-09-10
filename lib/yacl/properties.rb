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
  # In a Properties, all keys are strings.
  #
  class Properties
    extend Forwardable

    # Internal: returns the list of methods to delegate to the internal Map
    # instance
    #
    # Returns an Array of method names
    def self.delegating_to_map
      [ :set, :get, :fetch, :store, :delete, :clear, :[], :[]=, :has_key?, :each, :length, :keys, :method_missing ]
    end

    # Internal: Returns the list of methods that may be delegated to a
    # Properties instance.
    #
    # Returns an Array of method names
    def self.delegatable_methods
      delegating_to_map + [ :scoped_by, :scopes, :has_scope? ]
    end

    # Currently wrapping a map
    def_delegators :@map, *Properties.delegating_to_map

    def initialize( initial = {} )
      @map = Map.new
      expanded_keys( initial ) do |k,v|
        k << v
        @map.set( *k )
      end
    end

    # Return a new Properties that is a subset of the properties with the first
    # prefix removed.
    def scoped_by( *scope )
      scope = scope.length == 1 ? scope.first : scope
      sub_map = @map.get( expand_key( scope ) ) || {}
      Properties.new( sub_map )
    end

    def scopes
      scope_names.to_a.sort
    end

    def has_scope?( scope )
      scope_names.include?( scope )
    end

    private

    def scope_names
      keys.map { |k| k.to_s }
    end

    def expanded_keys( hash )
      hash.each do |k,v|
        yield expand_key( k ), v
      end
    end

    def expand_key( str )
      case str
      when Array
        str
      when /\./
        str.split(".")
      else
        [ str ]
      end
    end
  end
end
