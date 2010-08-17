# Taken from http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/100177
class Exception
  def errmsg
    "%s: %s\n%s" % [self.class, message, (backtrace || []).join("\n") << "\n"]
  end
end

# Taken from Active Support
class Array
  # Extracts options from a set of arguments. Removes and returns the last
  # element in the array if it's a hash, otherwise returns a blank hash.
  #
  #   def options(*args)
  #     args.extract_options!
  #   end
  #
  #   options(1, 2)           # => {}
  #   options(1, 2, :a => :b) # => {:a=>:b}
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end
end

# Extracted from truthy (http://github.com/ymendel/truthy/tree/master/lib/truthy.rb)
# and Rails (http://github.com/rails/rails/commit/823b623fe2de8846c37aa13250010809ac940b57)

class Object

  # Tricky, tricky! (-:
  def truthy?
    !!self
  end

  # Tries to send the method only if object responds to it. Return +nil+ otherwise.
  # It will also forward any arguments and/or block like Object#send does.
  #
  # ==== Example :
  #
  # # Without try
  # @person ? @person.name : nil
  #
  # With try
  # @person.try(:name)
  #
  # # try also accepts arguments/blocks for the method it is trying
  # Person.try(:find, 1)
  # @people.try(:map) {|p| p.name}
  #
  def try(method, *args, &block)
    send(method, *args, &block) if respond_to?(method)
  end

  # List unique local methods
  # Taken from http://giantrobots.thoughtbot.com/2008/12/23/script-console-tips
  def local_methods
    (methods - Object.instance_methods).sort
  end

end

class String
  def self.random_uuid
    java.util.UUID.randomUUID.toString
  end

  def valid_uuid?
    !!(size == 36 && self =~ %r{^([A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12})$}i)
  end
end

# Taken from ActiveSupport
class Hash
  def slice(*keys)
    keys = keys.map! { |key| convert_key(key) } if respond_to?(:convert_key)
    hash = self.class.new
    keys.each { |k| hash[k] = self[k] if has_key?(k) }
    hash
  end

  def slice!(*keys)
    keys = keys.map! { |key| convert_key(key) } if respond_to?(:convert_key)
    omit = slice(*self.keys - keys)
    hash = slice(*keys)
    replace(hash)
    omit
  end

  def except(*keys)
    dup.except!(*keys)
  end

  def except!(*keys)
    keys.map! { |key| convert_key(key) } if respond_to?(:convert_key)
    keys.each { |key| delete(key) }
    self
  end
end