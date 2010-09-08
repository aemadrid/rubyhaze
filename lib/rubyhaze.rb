raise "Rubyhaze only runs on JRuby. Sorry!" unless (RUBY_PLATFORM =~ /java/)
$: << File.dirname(__FILE__)
require 'java'

module RubyHaze

  class Exception < StandardError; end
  class HazelcastException < StandardError; end

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

    def connected?
      !!@connected
    end

    # To start a cluster we can pass a hash of options or nil to load it from ./hazelcast.yml if available and a Config
    # object will be generated.
    def init(options = nil)
      if connected?
        puts ">> Already connected with Hazelcast ..."
        false
      else
        if options
          config = RubyHaze::Config.new(options).proxy_object
          Hazelcast.init config
        else
          Hazelcast.cluster
        end
        @connected = true
      end
    end

    def shutdown
      @connected = false
      Hazelcast.shutdown
    end

    def random_uuid
      java.util.UUID.randomUUID.to_string
    end

    def valid_uuid?(uuid)
      !!(uuid.is_a?(String) &&
         uuid.size == 36 &&
         uuid =~ %r{^([A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12})$}i)
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

at_exit do
  if RubyHaze.connected?
    puts ">> Shutting down Hazelcast before closing shop ..."
    RubyHaze.shutdown
    puts ">>  ... done!"
  end
end

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

RH = RubyHaze unless defined? RH