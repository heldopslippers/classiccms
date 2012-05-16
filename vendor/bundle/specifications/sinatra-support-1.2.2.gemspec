# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sinatra-support"
  s.version = "1.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Cyril David", "Rico Sta. Cruz"]
  s.date = "2011-08-31"
  s.description = "Sinatra-support includes many helpers for forms, errors and many amazing things."
  s.email = ["cyx.ucron@gmail.com", "rico@sinefunc.com"]
  s.homepage = "http://sinefunc.com/sinatra-support"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.21"
  s.summary = "A gem with many essential helpers for creating web apps with Sinatra."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, [">= 1.0"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
      s.add_development_dependency(%q<ohm>, ["~> 0.0.38"])
      s.add_development_dependency(%q<haml>, ["~> 3.1.2"])
      s.add_development_dependency(%q<mocha>, ["~> 0.9.12"])
      s.add_development_dependency(%q<nokogiri>, ["~> 1.5.0"])
      s.add_development_dependency(%q<contest>, ["~> 0.1.3"])
      s.add_development_dependency(%q<compass>, ["~> 0.11.5"])
      s.add_development_dependency(%q<coffee-script>, ["~> 2.1.1"])
      s.add_development_dependency(%q<jsmin>, ["~> 1.0.1"])
      s.add_development_dependency(%q<i18n>, [">= 0"])
      s.add_development_dependency(%q<less>, [">= 0"])
    else
      s.add_dependency(%q<sinatra>, [">= 1.0"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<ohm>, ["~> 0.0.38"])
      s.add_dependency(%q<haml>, ["~> 3.1.2"])
      s.add_dependency(%q<mocha>, ["~> 0.9.12"])
      s.add_dependency(%q<nokogiri>, ["~> 1.5.0"])
      s.add_dependency(%q<contest>, ["~> 0.1.3"])
      s.add_dependency(%q<compass>, ["~> 0.11.5"])
      s.add_dependency(%q<coffee-script>, ["~> 2.1.1"])
      s.add_dependency(%q<jsmin>, ["~> 1.0.1"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<less>, [">= 0"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 1.0"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<ohm>, ["~> 0.0.38"])
    s.add_dependency(%q<haml>, ["~> 3.1.2"])
    s.add_dependency(%q<mocha>, ["~> 0.9.12"])
    s.add_dependency(%q<nokogiri>, ["~> 1.5.0"])
    s.add_dependency(%q<contest>, ["~> 0.1.3"])
    s.add_dependency(%q<compass>, ["~> 0.11.5"])
    s.add_dependency(%q<coffee-script>, ["~> 2.1.1"])
    s.add_dependency(%q<jsmin>, ["~> 1.0.1"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<less>, [">= 0"])
  end
end
