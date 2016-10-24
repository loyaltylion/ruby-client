$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'loyaltylion/version'

Gem::Specification.new do |gem|
  gem.name = 'loyaltylion'
  gem.version = LoyaltyLion::VERSION
  gem.author = 'LoyaltyLion'
  gem.email = 'support@loyaltylion.com'
  gem.description = 'Interact with LoyaltyLion from Ruby. See https://loyaltylion.com/docs for more'
  gem.summary = 'Ruby bindings for the LoyaltyLion API'
  gem.homepage = 'https://loyaltylion.com/docs'

  gem.add_dependency('httparty', '>= 0.8.1')

  gem.files = `git ls-files`.split("\n")
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
