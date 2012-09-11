# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "classiccms/version"

Gem::Specification.new do |s|
  s.name        = "classiccms"
  s.version     = Classiccms::VERSION
  s.authors     = ["jeljer te Wies"]
  s.email       = ["heldopslippers@gmail.com"]
  s.homepage    = "http://github.com/heldopslippers/classiccms"
  s.summary     = %q{An easy to use wrapper for creating basic and more complicated websites}
  s.description = %q{Webcms is a wrapper that automatigically will create a layer. It enables programmers to quickly build and release websites with CRUD CMS capabilities}

  s.rubyforge_project = "classiccms"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "rack-test"


  #database
  s.add_runtime_dependency "mongoid", '3.0.4'
  
  #web server
  s.add_runtime_dependency "sinatra"
  s.add_runtime_dependency "sinatra-support"
  s.add_runtime_dependency "sinatra-contrib"

  #background processing
  s.add_runtime_dependency "celluloid", "~> 0.11.1"

  #file upload
  s.add_runtime_dependency "dragonfly"

  #mail
  s.add_runtime_dependency "mail"

  #templating
  s.add_runtime_dependency "tilt"
  s.add_runtime_dependency "haml"
  s.add_runtime_dependency "sass"
  s.add_runtime_dependency "slim"
  s.add_runtime_dependency "coffee-script"

  #encryption
  s.add_runtime_dependency "encryptor"
end

