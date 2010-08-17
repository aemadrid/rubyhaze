raise "Rubyhaze only runs on JRuby. Sorry!" unless (RUBY_PLATFORM =~ /java/)
$: << File.dirname(__FILE__)
require 'java'

module RubyHaze

  class Exception < StandardError; end
  class HazelcastException < StandardError; end

  ROOT     = File.expand_path File.join(File.dirname(__FILE__), '..') unless defined? ROOT
  TMP_PATH = (ENV['RUBYHAZE_TMP_PATH'] || ROOT + '/tmp')

  $CLASSPATH << TMP_PATH

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

    def connect(config = nil)
      config = config.try(:proxy_object)
      Hazelcast.init config if config
      at_exit do
        puts ">> Shutting down Hazelcast ..."
        Hazelcast.shutdown
        puts ">>  ... done!"
      end
      Hazelcast.cluster      
    end

    def respond_to?(meth)
      Hazelcast.respond_to?(meth) || super
    end

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
require 'rubyhaze/configs/config'

require 'rubyhaze/stored'

RH = RubyHaze unless defined? RH