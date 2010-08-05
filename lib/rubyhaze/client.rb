require 'java'

module RubyHaze

  MODE         = "client" unless defined? MODE
  GEM_JAR_PATH = File.expand_path(File.dirname(__FILE__) + '/../../jars/hazelcast-client-1.8.5.jar')  unless defined? GEM_JAR_PATH
  JAR_PATH     = ENV['HAZELCAST_JAR_PATH'] || GEM_JAR_PATH  unless defined? JAR_PATH

end

require File.expand_path(File.dirname(__FILE__) + '/../../lib/rubyhaze')

