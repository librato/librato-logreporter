$:.push File.expand_path("../lib", __FILE__)

require "librato/logreporter/version"

Gem::Specification.new do |s|
  s.name        = "librato-logreporter"
  s.version     = Librato::LogReporter::VERSION
  s.license     = 'BSD 3-clause'

  s.authors     = ["Matt Sanders"]
  s.email       = ["matt@librato.com"]
  s.homepage    = "https://github.com/librato/librato-logreporter"

  s.summary     = "Write Librato metrics to your logs with a convenient interface"
  s.description = "Provides a simple interface to log Librato metrics to your log files in l2met format."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md", "CHANGELOG.md"]
  s.test_files = Dir["test/**/*"]

  s.add_development_dependency "minitest"
end
