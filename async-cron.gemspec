# frozen_string_literal: true

require_relative "lib/async/cron/version"

Gem::Specification.new do |spec|
	spec.name = "async-cron"
	spec.version = Async::Cron::VERSION
	
	spec.summary = "A scheduling service using cron-style syntax."
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.cert_chain  = ['release.cert']
	spec.signing_key = File.expand_path('~/.gem/release.pem')
	
	spec.homepage = "https://github.com/socketry/async-cron"
	
	spec.metadata = {
		"documentation_uri" => "https://socketry.github.io/async-cron/",
		"funding_uri" => "https://github.com/sponsors/ioquatix",
		"source_code_uri" => "https://github.com/socketry/async-cron.git",
	}
	
	spec.files = Dir.glob(['{lib}/**/*', '*.md'], File::FNM_DOTMATCH, base: __dir__)
	
	spec.required_ruby_version = ">= 3.1"
	
	spec.add_dependency "async"
end
