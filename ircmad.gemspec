# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ircmad/version'

Gem::Specification.new do |gem|
  gem.name          = "ircmad"
  gem.version       = Ircmad::VERSION
  gem.authors       = ["Takatoshi Matsumoto"]
  gem.email         = ["toqoz403@gmail.com"]
  gem.description   = %q{Bringing IRC into WebSocket}
  gem.summary       = %q{Bringing IRC into WebSocket. This enable to assess IRC through WebSocket easily.}
  gem.homepage      = "http://github.com/ToQoz/ircmad"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "eventmachine"
  gem.add_dependency "em-websocket"
  gem.add_dependency "zircon"
end
