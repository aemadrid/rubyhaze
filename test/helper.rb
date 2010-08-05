require File.expand_path(File.dirname(__FILE__) + '/../lib/rubyhaze/node')

require 'test/unit'

class Foo
  include RubyHaze::Stored
  field :name, :string
  field :age, :int
end unless defined? Foo

RubyHaze.cluster