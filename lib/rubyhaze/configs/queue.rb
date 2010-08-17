require File.expand_path(File.dirname(__FILE__) + '/../../../lib/rubyhaze')

class RubyHaze::QueueConfig

  include RubyHaze::Mixins::Proxy

  java_import 'com.hazelcast.config.QueueConfig'

  proxy_accessors :max_size_per_jvm, :name, :time_to_live_seconds

  def initialize(name, options = nil)
    @proxy_object = Java::ComHazelcastMapConfig::MapConfig.new
    self.name = name.to_s
    options ||= self.class.default_options
    options.each { |k,v| send "#{k}=", v }
  end

  class << self

    def default_options
      { :max_size_per_jvm => 10000, :time_to_live_seconds => 0 }
    end

    def [](name)
      RubyHaze.config.queue_config name.to_s
    end

  end

end
