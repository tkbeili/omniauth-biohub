# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'omniauth/portal_client/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-portal_client"
  spec.version       = OmniAuth::PortalClient::VERSION
  spec.authors       = ["I-Lung Lee"]
  spec.email         = ["ilunglee228@gmail.com"]
  spec.summary       = %q{client to use the portal server app}
  spec.description   = %q{Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'omniauth-oauth2', '~> 1.1'

  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'rake'

  spec.add_runtime_dependency 'gem_config'
end
