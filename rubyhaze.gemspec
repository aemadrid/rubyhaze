# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rubyhaze}
  s.version = "0.0.2"
  s.platform = %q{jruby}

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adrian Madrid"]
  s.date = %q{2010-08-16}
  s.default_executable = %q{rh_console}
  s.description = %q{RubyHaze is a little gem that wraps the Java Hazelcast library into a more comfortable Ruby package (in JRuby, of course).}
  s.email = %q{aemadrid@gmail.com}
  s.executables = ["rh_console"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/rh_console",
     "lib/rubyhaze.rb",
     "lib/rubyhaze/client.rb",
     "lib/rubyhaze/configs/config.rb",
     "lib/rubyhaze/configs/group.rb",
     "lib/rubyhaze/configs/map.rb",
     "lib/rubyhaze/configs/queue.rb",
     "lib/rubyhaze/core_ext.rb",
     "lib/rubyhaze/list.rb",
     "lib/rubyhaze/lock.rb",
     "lib/rubyhaze/map.rb",
     "lib/rubyhaze/mixins/compare.rb",
     "lib/rubyhaze/mixins/do_proxy.rb",
     "lib/rubyhaze/mixins/native_exception.rb",
     "lib/rubyhaze/mixins/proxy.rb",
     "lib/rubyhaze/multi_map.rb",
     "lib/rubyhaze/node.rb",
     "lib/rubyhaze/queue.rb",
     "lib/rubyhaze/set.rb",
     "lib/rubyhaze/stored.rb",
     "lib/rubyhaze/stores/fake_store.rb",
     "lib/rubyhaze/topic.rb",
     "test/test_stored.rb"
  ]
  s.homepage = %q{http://github.com/aemadrid/rubyhaze}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{JRuby wrapper to play with Hazelcast}
  s.test_files = [
    "test/test_stored.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bitescript>, [">= 0"])
    else
      s.add_dependency(%q<bitescript>, [">= 0"])
    end
  else
    s.add_dependency(%q<bitescript>, [">= 0"])
  end
end

