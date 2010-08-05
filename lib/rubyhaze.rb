require 'java'

module RubyHaze

  class Exception < StandardError; end

  ROOT     = File.expand_path File.join(File.dirname(__FILE__), '..') unless defined? ROOT
  LIB_PATH = ROOT + "/lib/rubyhaze" unless defined? LIB_PATH
  TMP_PATH = (ENV['RUBYHAZE_TMP_PATH'] || ROOT + '/tmp')

  $CLASSPATH << TMP_PATH

  unless defined? MODE
    require LIB_PATH + '/' + (ENV['RUBYHAZE_MODE'] || 'node')
  end

  puts ">> Loading Hazelcast #{MODE} library..."
  if File.file?(JAR_PATH)
    require JAR_PATH
    java_import 'com.hazelcast.core.Hazelcast'
    Hazelcast.get_cluster
    puts ">> ... loaded!"
  else
    puts "ERROR! Could not find the Hazelcast JAR file in [#{JAR_PATH}]."
    abort
  end

  %w{core_ext base_mixin map multi_map set list queue topic lock stored}.each do |name|
    require LIB_PATH + '/' + name
  end

  class << self

    java_import 'com.hazelcast.core.Hazelcast'

    def instances
      Hazelcast.get_instances
    end

    def cluster
      Hazelcast.get_cluster
    end

    def config
      Hazelcast.get_config
    end

  end

end

RH = RubyHaze unless defined? RH