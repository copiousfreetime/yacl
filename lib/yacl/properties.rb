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

    # Currently wrapping a hash.
    def_delegators :@map, :fetch, :store, :delete, :clear, :[], :[]=, :has_key?, :each, :length, :keys, :method_missing

    def initialize( initial = {} )
      @map = Map.new
      expanded_keys( initial ) do |k,v|
        k << v
        @map.set( *k )
      end
    end

    # Return a new Properties that is a subset of the properties with the first
    # prefix removed.
    def scoped_by( scope )
      Properties.new( fetch( scope ) )
    end

    def scopes
      scope_names.to_a.sort
    end

    def has_scope?( scope )
      scope_names.include?( scope )
    end

    private

    def scope_names
      s = Set.new
      keys.each do |k|
        s << k.split(".").first
      end
      return s
    end

    def expanded_keys( hash )
      hash.each do |k,v|
        yield [k],v unless k =~ /\./
        yield k.split('.'), v
      end
    end
  end
end
