require File.expand_path(File.dirname(__FILE__) + '/../../lib/rubyhaze')

class RubyHaze::Map

  include RubyHaze::Mixins::DOProxy

  java_import 'com.hazelcast.query.SqlPredicate'

  def initialize(name)
    @name = name.to_s
    @proxy_object = Hazelcast.get_map @name
  rescue NativeException => x
    rescue_native_exception x
  end

  def each
    proxy_object.each do |(key, value)|
      yield key, value
    end
  rescue NativeException => x
    rescue_native_exception x
  end
  
  def [](key)
    proxy_object[key.to_s]
  rescue NativeException => x
    rescue_native_exception x
  end
  
  def []=(key,value)
    proxy_object[key.to_s] = value
  rescue NativeException => x
    rescue_native_exception x
  end

  def keys(predicate = nil)
    predicate = prepare_predicate(predicate) unless predicate.is_a?(SqlPredicate)
    proxy_object.key_set(predicate).map
  rescue NativeException => x
    rescue_native_exception x
  end

  def values(predicate = nil)
    predicate = prepare_predicate(predicate) unless predicate.is_a?(SqlPredicate)
    proxy_object.values(predicate).map
  rescue NativeException => x
    rescue_native_exception x
  end
  alias :find :values

  def local_keys(predicate = nil)
    predicate = prepare_predicate(predicate) unless predicate.is_a?(SqlPredicate)
    proxy_object.local_key_set(predicate).map
  rescue NativeException => x
    rescue_native_exception x
  end

  def local_stats
    lsm = proxy_object.local_map_stats
    { :backup_count => lsm.backup_entry_count, :backup_memory => lsm.backup_entry_memory_cost,
      :created => lsm.creation_time, :last_accessed => lsm.last_access_time,  }
  end

  def prepare_predicate(predicate)
    return if predicate.nil?
    case predicate
      when String
        SqlPredicate.new predicate
      when Hash
        query = predicate.map do |field, value|
          cmp = '='
          if value.is_a?(String)
            value = "'" + value + "'"
            cmp = 'LIKE' if value.index('%')
          end
          "#{field} #{cmp} #{value}"
        end.join(' AND ')
        SqlPredicate.new query
      else
        raise "Unknown predicate type"
    end
  end

end

RubyHaze::Hash = RubyHaze::Map unless defined? RubyHaze::Hash


