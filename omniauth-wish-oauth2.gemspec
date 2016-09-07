# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
version = File.read(File.expand_path('../lib/version', __FILE__)).strip

Gem::Specification.new do |spec|
  spec.name          = "omniauth-wish-oauth2"
  spec.version       = version
  spec.authors       = ["xiajian"]
  spec.email         = ["jhqy2011@gmail.com"]
  spec.summary       = %q{wish merchant oauth2 gem.}
  spec.description   = %q{wish merchant oauth2 gem.}
  spec.homepage      = "https://github.com/xiajian/omniauth-wish-oauth2.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency             'omniauth',        '~> 1.0'
  spec.add_dependency             'omniauth-oauth2', '~> 1.0'
  
  spec.add_development_dependency 'rspec',           '~> 3.0'
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
