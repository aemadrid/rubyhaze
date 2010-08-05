require 'java'

module RubyHaze

  NODE_JAR_PATH = ENV['HAZELCAST_NODE_JAR_PATH'] || File.expand_path(File.dirname(__FILE__) + '/../../jars/hazelcast-1.8.5.jar')

  puts ">> Loading Hazelcast node library..."
  require NODE_JAR_PATH
  java_import 'com.hazelcast.core.Hazelcast'
  Hazelcast.get_cluster
  puts ">> ... loaded!"
  
end

require File.expand_path(File.dirname(__FILE__) + '/../../lib/rubyhaze')

