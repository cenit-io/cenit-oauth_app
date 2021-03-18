require_relative 'lib/cenit/oauth_app/version'

Gem::Specification.new do |spec|
  spec.name          = "cenit-oauth_app"
  spec.version       = Cenit::OauthApp.version
  spec.authors       = ["Maikel Arcia"]
  spec.email         = ["mac@cenit.io"]

  spec.summary       = %q{OAuth capabilities for build-in apps.}
  spec.description   = %q{Provide OAuth capabilities to build-in apps.}
  spec.homepage      = "https://cenit.io"
  spec.license       = "MIT"
end
