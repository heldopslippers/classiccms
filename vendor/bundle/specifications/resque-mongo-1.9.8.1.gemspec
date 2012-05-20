# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "resque-mongo"
  s.version = "1.9.8.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Christos Trochalakis"]
  s.date = "2010-07-26"
  s.description = "    Resque-mongo is a fork of resque that uses mongo as a queue backend.\n\n    Resque is a Redis-backed Ruby library for creating background jobs,\n    placing those jobs on multiple queues, and processing them later.\n\n    Background jobs can be any Ruby class or module that responds to\n    perform. Your existing classes can easily be converted to background\n    jobs or you can create new classes specifically to do work. Or, you\n    can do both.\n\n    Resque is heavily inspired by DelayedJob (which rocks) and is\n    comprised of three parts:\n\n    * A Ruby library for creating, querying, and processing jobs\n    * A Rake task for starting a worker which processes jobs\n    * A Sinatra app for monitoring queues, jobs, and workers.\n"
  s.email = "yatiohi@ideopolis.gr"
  s.executables = ["resque", "resque-web"]
  s.extra_rdoc_files = ["LICENSE", "README.markdown"]
  s.files = ["bin/resque", "bin/resque-web", "LICENSE", "README.markdown"]
  s.homepage = "http://github.com/ctrochalakis/resque-mongo"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.21"
  s.summary = "Resque-mongo is resque fork with a mongo backend."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongo>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<vegas>, ["~> 0.1.2"])
      s.add_runtime_dependency(%q<sinatra>, [">= 0.9.2"])
      s.add_runtime_dependency(%q<json>, [">= 1.1.0"])
    else
      s.add_dependency(%q<mongo>, [">= 1.0.0"])
      s.add_dependency(%q<vegas>, ["~> 0.1.2"])
      s.add_dependency(%q<sinatra>, [">= 0.9.2"])
      s.add_dependency(%q<json>, [">= 1.1.0"])
    end
  else
    s.add_dependency(%q<mongo>, [">= 1.0.0"])
    s.add_dependency(%q<vegas>, ["~> 0.1.2"])
    s.add_dependency(%q<sinatra>, [">= 0.9.2"])
    s.add_dependency(%q<json>, [">= 1.1.0"])
  end
end
