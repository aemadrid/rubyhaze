require File.expand_path(File.dirname(__FILE__) + '/../../lib/rubyhaze')

class RubyHaze::Map

  include RubyHaze::BaseMixin

  java_import 'com.hazelcast.query.SqlPredicate'

  def initialize(name)
    @name = name.to_s
    @hco = Hazelcast.get_map @name
  rescue => e
    puts e.errmsg
  end

  def each
    @hco.each do |(key, value)|
      yield key, value
    end
  rescue => e
    puts e.errmsg
  end
  
  def [](key)
    @hco[key.to_s]
  rescue NativeException => x
    x = x.cause while x.cause
    x.print_stack_trace
  rescue => e
    puts e.errmsg
  end
  
  def []=(key,value)
    @hco[key.to_s] = value
  rescue NativeException => x
    x = x.cause while x.cause
    x.print_stack_trace
  rescue => e
    puts e.errmsg
  end

  def keys(predicate = nil)
    @hco.key_set(prepare_predicate(predicate)).map
  rescue NativeException => x
    x = x.cause while x.cause
    x.print_stack_trace
  rescue => e
    puts e.errmsg
  end

  def values(predicate = nil)
    @hco.values(prepare_predicate(predicate)).map
  rescue NativeException => x
    x = x.cause while x.cause
    x.print_stack_trace
  rescue => e
    puts e.errmsg
  end

  def local_keys(predicate = nil)
    @hco.local_key_set(prepare_predicate(predicate)).map
  rescue NativeException => x
    x = x.cause while x.cause
    x.print_stack_trace
  rescue => e
    puts e.errmsg
  end

  def local_stats
    lsm = @hco.local_map_stats
    { :backup_count => lsm.backup_entry_count, :backup_memory => lsm.backup_entry_memory_cost,
      :created => lsm.creation_time, :last_accessed => lsm.last_access_time,  }
  rescue => e
    puts e.errmsg
  end

  private
  
  def prepare_predicate(predicate)
    return if predicate.nil?
    case predicate
      when String
        SqlPredicate.new predicate
      when Hash
        SqlPredicate.new predicate.map{|k,v| "#{k} = #{v}"}.join(' AND ')
      when SqlPredicate
        predicate
      else
        raise "Unknown predicate type"
    end
  end
end

RubyHaze::Hash = RubyHaze::Map unless defined? RubyHaze::Hash


