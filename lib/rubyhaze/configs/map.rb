require File.expand_path(File.dirname(__FILE__) + '/../../../lib/rubyhaze')

class RubyHaze::MapConfig

  include RubyHaze::Mixins::Proxy

  java_import 'com.hazelcast.config.MapConfig'

  proxy_accessors :backup_count, :eviction_delay_seconds, :eviction_percentage, :eviction_policy, :map_store_config,
                  :max_idle_seconds, :max_size, :name, :near_cache_config, :time_to_live_seconds

  def initialize(name, options = nil)
    @proxy_object = Java::ComHazelcastConfig::MapConfig.new
    self.name = name.to_s
    options ||= self.class.default_options
    options.each { |k,v| send "#{k}=", v }
  end

  class << self

    def default_options
      { :backup_count => 1, :eviction_policy => 'NONE', :max_size => 0, :eviction_percentage => 25 }
    end

    def [](name)
      RubyHaze.config.map_config name.to_s
    end

  end

end
