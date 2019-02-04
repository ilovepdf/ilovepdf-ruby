# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ilovepdf/version'

Gem::Specification.new do |spec|
  spec.name          = "ilovepdf"
  spec.version       = Ilovepdf::VERSION
  spec.authors       = ["Leonardo Collazo"]
  spec.email         = ["leonardo.chronicles@gmail.com"]

  spec.summary       = %q{A library in Ruby for iLovePDF Api}
  spec.description   = %q{Develop and automate PDF processing tasks like Compress PDF, Merge PDF, Split PDF, convert Office to PDF, PDF to JPG, Images to PDF, add Page Numbers, Rotate PDF, Unlock PDF, stamp a Watermark and Repair PDF. Each one with several settings to get your desired results.}
  spec.homepage      = "https://github.com/ilovepdf/ilovepdf-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.0'

  spec.add_runtime_dependency 'rest-client', '~> 2'
  spec.add_runtime_dependency 'jwt', '~> 2'


  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug", "~> 9"
  spec.add_development_dependency "webmock", "~> 3"
  spec.add_development_dependency "addressable", "~> 2.5"
end
