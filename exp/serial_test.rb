require 'rubygems'
require 'rubyhaze'

class Person1

  java_import 'com.hazelcast.nio.DataSerializable'
  include DataSerializable

  attr_accessor :name, :age

  def initialize(name, age)
    self.name, self.age = name, age
  end

  def write_data(output)
    output.write_utf name
    output.write_int age
  end

  def read_data(input)
    self.name = input.read_utf
    self.age = input.read_int
  end

end

class Person2

  java_import 'java.io.Serializable'
  include Serializable

  attr_accessor :name, :age

  def initialize(name, age)
    self.name, self.age = name, age
  end

  def write_object(output)
    output.write_utf name
    output.write_int age
  end

  def read_object(input)
    self.name = input.read_utf
    self.age = input.read_int
  end

end

def lbl(msg)
  puts "-"*120
  puts msg
end

lbl "Creating distributed hash..."
hash = RubyHaze::Hash[:test]

lbl "Creating person 1 [com.hazelcast.nio.DataSerializable]"
p1 = Person1.new "Tester1", 30
lbl "Person 1 : #{p1.inspect}"
lbl "Creating person 2 [java.io.Serializable]"
p2 = Person2.new "Tester2", 40
lbl "Person 2 : #{p2.inspect}"

lbl "Saving person 1"
hash[:p1] = p1
lbl "Saving person 2"
hash[:p2] = p2

lbl "Retrieving person 1b"
p1b = hash[:p1]
lbl "Person 1b : #{p1b.inspect}"
lbl "Retrieving person 2b"
p2b = hash[:p2]
lbl "Person 2b : #{p2b.inspect}"

lbl "THE END"




