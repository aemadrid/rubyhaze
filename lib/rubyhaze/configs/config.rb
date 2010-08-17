require File.expand_path(File.dirname(__FILE__) + '/../../../lib/rubyhaze')

class RubyHaze::Config

  include RubyHaze::Mixins::Proxy

  java_import 'com.hazelcast.config.Config'
  java_import 'java.net.URL'
  java_import 'java.io.File'

  def initialize(options = {})
    @proxy_object = Java::ComHazelcastConfig::Config.new
    set_group   options[:group]
    set_network options[:network]
    set_maps    options[:maps]
    set_queues  options[:queues]
    set_topics  options[:topics]
  end

  def set_group(options = nil)
    options ||= RubyHaze::GroupConfig.default_options
    proxy_object.setGroupConfig RubyHaze::GroupConfig.new(options).proxy_object
  end

  def set_network(options = nil)
    options ||= RubyHaze::NetworkConfig.default_options
    proxy_object.setNetworkConfig RubyHaze::NetworkConfig.new(options).proxy_object
  end

  def set_maps(hash = nil)
    return if hash.nil? || hash.empty?
    proxy_object.setMapConfigs hash.map{ |name, options| RubyHaze::MapConfig.new(name, options).proxy_object }
  end

  def set_queues(hash = nil)
    return if hash.nil? || hash.empty?
    proxy_object.setMapQConfigs hash.map{ |name, options| RubyHaze::QueueConfig.new(name, options).proxy_object }
  end

  def set_topics(hash = nil)
    return if hash.nil? || hash.empty?
    proxy_object.setTopicConfigs hash.map{ |name, options| RubyHaze::TopicConfig.new(name, options).proxy_object }
  end

  class << self

    def yaml_hash
      yml_path = File.expand_path('./hazelcast.yml')
      YAML.load_file(yml_path) if File.file? yml_path
    end

    def new_from_yaml
      hsh = yaml_hash
      new(hsh) if hsh
    end

  end

end
