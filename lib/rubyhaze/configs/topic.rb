require File.expand_path(File.dirname(__FILE__) + '/../../../lib/rubyhaze')

class RubyHaze::TopicConfig

  include RubyHaze::Mixins::Proxy

  java_import 'com.hazelcast.config.TopicConfig'

  proxy_accessors [:global_ordering?, :global_ordering_enabled], :name

  def initialize(name, options = nil)
    @proxy_object = Java::ComHazelcastConfig::TopicConfig.new
    self.name = name.to_s
    options ||= self.class.default_options
    options.each { |k,v| send "#{k}=", v }
  end

  class << self

    def default_options
      {}
    end

    def [](name)
      RubyHaze.config.topic_config name.to_s
    end

  end

end
