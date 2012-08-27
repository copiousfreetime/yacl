require 'forwardable'

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
    def_delegators :@map, :fetch, :store, :delete, :clear, :[], :[]=, :has_key?, :each, :length, :keys

    def initialize( initial = {} )
      @map = Hash.new
      initial.each do |k,v|
        store(k.to_s, v)
      end
    end

    # Return a new Properties that is a subset of the properties with the first
    # prefix removed.
    def scoped_by( scope )
      s_props = Properties.new
      each do |k,v|
        if md = k.match( /\A(#{scope})\.(.*)\Z/ ) then
          s_props.store( md.captures.last, v )
        end
      end
      return s_props
    end
  end
end
