# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "qu-mongo"
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brandon Keepers"]
  s.date = "2012-01-07"
  s.description = "Mongo backend for qu"
  s.email = ["brandon@opensoul.org"]
  s.homepage = "http://github.com/bkeepers/qu"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.21"
  s.summary = "Mongo backend for qu"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongo>, [">= 0"])
      s.add_runtime_dependency(%q<qu>, ["= 0.1.4"])
      s.add_development_dependency(%q<bson_ext>, [">= 0"])
    else
      s.add_dependency(%q<mongo>, [">= 0"])
      s.add_dependency(%q<qu>, ["= 0.1.4"])
      s.add_dependency(%q<bson_ext>, [">= 0"])
    end
  else
    s.add_dependency(%q<mongo>, [">= 0"])
    s.add_dependency(%q<qu>, ["= 0.1.4"])
    s.add_dependency(%q<bson_ext>, [">= 0"])
  end
end
