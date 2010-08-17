require File.expand_path(File.dirname(__FILE__) + '/../../../lib/rubyhaze')

class RubyHaze::GroupConfig

  include RubyHaze::Mixins::Proxy

  java_import 'com.hazelcast.config.GroupConfig'

  proxy_accessors [:username, :name], :password

  def initialize(options = {})
    @proxy_object = Java::ComHazelcastConfig::GroupConfig.new
    options.each { |k,v| send "#{k}=", v }
  end

  class << self

    def default_options
      { :username => 'dev', :password => 'dev-pass' }
    end

  end

end
