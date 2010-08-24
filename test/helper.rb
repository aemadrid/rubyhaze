require File.expand_path(File.dirname(__FILE__) + '/../lib/rubyhaze')
require 'test/unit'
require 'forwardable'

class Notices
  class << self
    extend Forwardable
    def all
      @all ||= []
    end
    def_delegators :all, :size, :<<, :first, :last, :clear, :map
  end
end unless defined? Notices

