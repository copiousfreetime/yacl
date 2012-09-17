require 'yacl'
module MyApp
  # The core defaults of your system. Not all of your default properties need to
  # be defined. It is your choice what is defined and what isn't. Think of these
  # as the hardcoded defaults that if the property is not overwritte by
  # something else in the system, then it will fall back to this. 
  #
  # Sensible Defaults in other words.
  #
  # Possible ways of using these:
  #
  #   - Have different Defaults for development/test/production
  #   - Use this for things that are hardly ever overwritten
  #   - global defaults that are common across many sub-components.
  #
  # It would be perfectly reasonable to have different classes defined for
  # different things. Different commandline applications, or entrypoints into
  # the library etc.
  class Defaults < Yacl::Define::Defaults
    default 'archive.uri'    , 'http://archive.example.com'
    default 'messaging.uri'  , 'kestrel://messaging1.example.com:2229/'
    default 'messaging.queue', 'pending'
    default 'system'         , 'main'
    default 'timelimit'      , '10'
  end
end


