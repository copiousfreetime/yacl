require 'yacl'
module MyApp
  class Defaults < Yacl::Define::Defaults
    default 'archive.uri'    , 'http://archive.collectiveintellect.com'
    default 'messaging.uri'  , 'kestrel://messaging1.collectiveintellect.com:2229/'
    default 'messaging.queue', 'frankensnip'
    default 'system'         , 'pipeline_main'
    default 'timelimit'      , '10'
  end
end


