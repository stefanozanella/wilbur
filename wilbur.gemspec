$:.unshift 'lib'
require 'wilbur/version'

Gem::Specification.new do |s|
  s.name              = "wilbur"
  s.version           = Wilbur::Version
  s.summary           = "Wilbur is a CLI tool that automates OpenWRT building process."
  s.homepage          = "https://github.com/stefanozanella/wilbur"
  s.email             = ["zanella.stefano@gmail.com"]
  s.authors           = ["Stefano Zanella"]

  s.files             = `git ls-files`.split($/)
  s.executables       = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files        = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths     = ["lib"]

  s.extra_rdoc_files  = ["README.md"]
  s.rdoc_options      = ["--charset=UTF-8"]

  s.add_runtime_dependency "thor"
  s.add_runtime_dependency "net-ssh"

  s.add_development_dependency "rake"
  s.add_development_dependency "minitest"
  s.add_development_dependency "coveralls"

  s.description = %s{
    Wilbur is primarly a wrapper around OpenWRT Buildroot.
    
    Building a custom OpenWRT image with a custom kernel is not so difficult if
    done once, but as long as you need to integrate it into your infrastructure
    things can start to scatter. Wilbur allows resources like kernel
    configurations, patches, custom config files to be sticked together and
    managed as a single, configurable and cloneable entity.
    
    Also, Wilbur provides a layer of abstraction over Vagrant and enables
    repeatable, predictable builds and repeatable, predictable deployments via
    network boot if your device support it.
  }
end
