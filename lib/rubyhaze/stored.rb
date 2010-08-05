require File.expand_path(File.dirname(__FILE__) + '/../../lib/rubyhaze')
require 'bitescript'

module RubyHaze::Stored

  def self.included(base)
    base.extend ClassMethods
  end

  def initialize(*args)
    return if args.empty?
    hash = args.extract_options!
    set hash if hash
    unless args.empty?
      args.each_with_index do |value, idx|
        set self.class.field_names[idx], value
      end
    end
  end

  def set(*args)
    if args.size == 2
      instance_variable_set "@#{args.first}", args.last
    elsif args.size == 1 && args.first.is_a?(Hash)
      args.first.each { |k,v| set k, v }
    else
      raise "Unknown parameters #{args.inspect} for set"
    end
  end

  def get(*args)
    if args.size == 1
      instance_variable_get "@#{args.first}"
    else
      args.map { |k| get k }
    end
  end

  def attributes
    self.class.field_names.map{ |name| [ name, instance_variable_get("@#{name}") ] }
  end

  def values
    self.class.field_names.map{ |name| instance_variable_get("@#{name}") }
  end

  def to_ary
    attributes.unshift [ 'class', self.class.name ]
  end

  def ==(other)
    return false unless other.respond_to? :to_ary
    to_ary == other.to_ary
  end

  def shadow_object
    self.class.store_java_class.new *values
  end

  def load_shadow_object(shadow)
    self.class.field_names.each do |name|
      instance_variable_set "@#{name}", shadow.send(name)
    end
    self
  end

  attr_accessor :uid

  def save
    @uid ||= String.random_uuid
    self.class.store[uid] = shadow_object
  end

  def load
    raise "Missing uid for load" if uid.nil?
    found = self.class.store[uid]
    raise "Record not found" unless found
    load_shadow_object(found)
    self
  end

  alias :reload :load

  def to_s
    "<" + self.class.name + " " + attributes[1..-1].inspect + " >"
  end

  module ClassMethods

    def create(*args)
      obj = new(*args)
      obj.save
      obj
    end

    def store
      @store ||= RubyHaze::Map.new store_java_class_name
    end

    def fields
      @fields ||= [
        [ :uid, :string, {} ]
      ]
    end

    def field_names()   fields.map { |ary| ary[0] } end
    def field_types()   fields.map { |ary| ary[1] } end
    def field_options() fields.map { |ary| ary[2] } end

    def field(name, type, options = {})
      puts "Defining :#{name}, :#{type}, #{options.inspect}..."
      raise "Field [#{name} already defined" if field_names.include?(name)
      fields << [ name, type, options ]
      attr_accessor name
    end

    def field_loads
      {
        :string => :aload,
        :int => :iload,
        :boolean => :iload,
        :double => :dload,
      }
    end

    def store_java_class_name
      'RubyHaze_Shadow__' + name 
    end

    def store_java_class
      RubyHaze.const_defined?(store_java_class_name) ?
        RubyHaze.const_get(store_java_class_name) :
        generate_java_class
    end

    def generate_java_class
      builder = BiteScript::FileBuilder.new store_java_class_name + '.class'
      class_dsl = []
      class_dsl << %{public_class "#{store_java_class_name}", object, Java::JavaIo::Serializable do}
      fields.each do |name, type, options|
        class_dsl << %{  public_field :#{name}, send(:#{type})}
      end
      class_dsl << %{  public_constructor [], #{field_types.map{|x| x.to_s}.join(', ')} do}
      class_dsl << %{    aload 0}
      class_dsl << %{    invokespecial object, "<init>", [void]}
      index = 1
      fields.each do |name, type, options|
        class_dsl << %{    aload 0}
        class_dsl << %{    #{field_loads[type]} #{index}}
        index += 1
        class_dsl << %{    putfield this, :#{name}, send(:#{type})}
      end
      class_dsl << %{    returnvoid}
      class_dsl << %{  end}
      class_dsl << %{end}
      class_dsl = class_dsl.join("\n")
      if $DEBUG
        FileUtils.mkdir_p RubyHaze::TMP_PATH
        filename = RubyHaze::TMP_PATH + '/' + store_java_class_name + '.bc'
        File.open(filename, 'w') { |file| file.write class_dsl }
      end
      builder.instance_eval class_dsl, __FILE__, __LINE__
      builder.generate do |builder_filename, class_builder|
        bytes = class_builder.generate
        klass = JRuby.runtime.jruby_class_loader.define_class store_java_class_name, bytes.to_java_bytes
        if $DEBUG
          filename = RubyHaze::TMP_PATH + '/' + builder_filename
          File.open(filename, 'w') { |file| file.write class_builder.generate }
        end
        RubyHaze.const_set store_java_class_name, JavaUtilities.get_proxy_class(klass.name)
      end
      RubyHaze.const_get store_java_class_name
    end

    def find(predicate)
      store.values(predicate).map { |shadow| new.load_shadow_object shadow }
    end

    def find_uids(predicate)
      store.keys(predicate)
    end
  end

end