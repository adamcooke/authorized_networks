require_relative './lib/authorized_networks/version'
Gem::Specification.new do |s|
  s.name          = "authorized_networks"
  s.description   = %q{An easy way to verify IPs are on authorized networkjs.}
  s.summary       = %q{This gem provides tooling to allow for IP addresses to be verified as belonging to authorized networks.}
  s.homepage      = "https://github.com/adamcooke/authorized_networks"
  s.version       = AuthorizedNetworks::VERSION
  s.files         = Dir.glob("{lib}/**/*")
  s.require_paths = ["lib"]
  s.authors       = ["Adam Cooke"]
  s.email         = ["me@adamcooke.io"]
  s.licenses      = ['MIT']
end
