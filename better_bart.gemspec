# -*- encoding: utf-8 -*-
require File.expand_path('../lib/bart/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ben Bergstein"]
  gem.email         = ["bennyjbergstein@gmail.com"]
  gem.description   = %q{Intuitive analog to BART's API}
  gem.summary       = %q{A better Bay Area Regional Transit Ruby API}

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "better_bart"
  gem.require_paths = ["lib"]
  gem.version       = Bart::VERSION
end
