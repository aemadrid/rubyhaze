require File.expand_path(File.dirname(__FILE__) + '/../../../lib/rubyhaze')

class RubyHaze::Config

  include RubyHaze::Mixins::Proxy

  java_import 'com.hazelcast.config.Config'
  java_import 'java.net.URL'
  java_import 'java.io.File'

  def initialize(*args)
    options = args.extract_options!
    @proxy_object = Java::ComHazelcastConfig::Config.new
    set_group_config options[:group]
    set_map_configs options[:maps]
  end

  def set_group_config(options = nil)
    options ||= RubyHaze::GroupConfig.default_options
    proxy_object.set_group_config RubyHaze::GroupConfig.new(options).proxy_object
  end

  def set_map_configs(hash = nil)
    return if hash.nil? || hash.empty?
    proxy_object.set_map_configs hash.map{ |name, options| RubyHaze::MapConfig.new(name, options).proxy_object }
  end

end
