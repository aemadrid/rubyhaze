raise "Rubyhaze only runs on JRuby. Sorry!" unless (RUBY_PLATFORM =~ /java/)
$: << File.dirname(__FILE__)
require 'java'

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

  unless @loaded
    puts ">> Loading Hazelcast #{MODE} library ..."
    if File.file?(JAR_PATH)
      require JAR_PATH
      puts ">> ... loaded!"
      @loaded = true
    else
      puts "ERROR! Could not find the Hazelcast JAR file in [#{JAR_PATH}]."
      abort
    end
  end

  class << self

    java_import 'com.hazelcast.core.Hazelcast'

    # To start a cluster we can pass a hash of options or nil to load it from ./hazelcast.yml if available and a Config
    # object will be generated.
    def init(options = nil)
      unless @connected
        if options
          config = RubyHaze::Config.new(options).proxy_object
          Hazelcast.init config
        end
        at_exit do
          puts ">> Shutting down Hazelcast ..."
          Hazelcast.shutdown
          puts ">>  ... done!"
        end
        @connected = true
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
require 'rubyhaze/configs/network'
require 'rubyhaze/configs/queue'
require 'rubyhaze/configs/config'

require 'rubyhaze/stored'

RH = RubyHaze unless defined? RH