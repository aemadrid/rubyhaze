unless HELPER_LOADED

  require File.expand_path(File.dirname(__FILE__) + '/../lib/rubyhaze')
  require 'test/unit'
  require 'forwardable'
  require 'date'

  # Load the Hazelcast cluster
  RubyHaze.init :group => { :username => "test", :password => "test" }

  # Grab notices
  class Notices
    class << self
      extend Forwardable
      def all
        @all ||= []
      end
      def_delegators :all, :size, :<<, :first, :last, :clear, :map
    end
  end

  # Listen on messages
  class TestListener
    def initialize(name)
      @name = name
    end
    def on_message(msg)
      Notices << "[#{@name}] #{msg}"
    end
  end

  # Finished loading helpers
  HELPER_LOADED = true

end
