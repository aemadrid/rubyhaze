raise "Rubyhaze only runs on JRuby. Sorry!" unless (RUBY_PLATFORM =~ /java/)
$: << File.dirname(__FILE__)
require 'java'
require 'yaml'

module RubyHaze

  class Exception < StandardError; end
  class HazelcastException < StandardError; end

  if $DEBUG
    TMP_PATH = (ENV['RUBYHAZE_TMP_PATH'] || File.join(File.dirname(__FILE__), '..', 'TMP'))
    $CLASSPATH << TMP_PATH
  end

  unless defined? MODE
    require 'rubyhaze/' + (ENV['RUBYHAZE_MODE'] || 'node')
  end

  puts ">> Loading Hazelcast #{MODE} library ..."
  if File.file?(JAR_PATH)
    require JAR_PATH
    puts ">> ... loaded!"
  else
    puts "ERROR! Could not find the Hazelcast JAR file in [#{JAR_PATH}]."
    abort
  end

  class << self

    java_import 'com.hazelcast.core.Hazelcast'

    # To start a cluster we can pass a hash (or load it from ./hazelcast.yml)  and a Config object will be generated or
    # pass a Java::ComHazelcastConfig::Config object. If we pass nothing and no yml file is found then Hazelcast will
    # look for a hazelcast.xml file in the CLASSPATH.
    def connect(config = nil)
      config = RubyHaze::Config.new config if config.is_a?(Hash)
      config ||= RubyHaze::Config.new_from_yaml
      config = config.proxy_object if config.is_a?(RubyHaze::Config)
      Hazelcast.init config if config
      at_exit do
        puts ">> Shutting down Hazelcast ..."
        Hazelcast.shutdown
        puts ">>  ... done!"
      end
      Hazelcast.cluster      
    end

    # Proxying to Hazelcast class
    def respond_to?(meth)
      super || Hazelcast.respond_to?(meth)
    end

    # Proxying to Hazelcast class
    def method_missing(meth, *args, &blk)
      if Hazelcast.respond_to? meth
        Hazelcast.send meth, *args, &blk
      else
        super
      end
    end

  end

end

require 'rubyhaze/core_ext'

require 'rubyhaze/mixins/proxy'
require 'rubyhaze/mixins/compare'
require 'rubyhaze/mixins/native_exception'
require 'rubyhaze/mixins/do_proxy'

require 'rubyhaze/map'
require 'rubyhaze/multi_map'
require 'rubyhaze/set'
require 'rubyhaze/list'
require 'rubyhaze/queue'
require 'rubyhaze/topic'
require 'rubyhaze/lock'

require 'rubyhaze/configs/group'
require 'rubyhaze/configs/map'
require 'rubyhaze/configs/queue'
require 'rubyhaze/configs/network'
require 'rubyhaze/configs/topic'
require 'rubyhaze/configs/config'

require 'rubyhaze/stored'

RH = RubyHaze unless defined? RH