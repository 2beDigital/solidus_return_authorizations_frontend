# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_return_authorizations_frontend'
  s.version     = '1.0.0'
  s.summary     = 'Allow customers to request returns'
  s.description = 'Allow customers to create a Return Request to be approved by Spree Admins'
  s.required_ruby_version = '>= 1.9.3'

  s.author    = 'Nebulab, 2bedigital'
  s.email     = 'info@nebulab.it, info@2bedigital.com'
  s.homepage  = 'http://github.com/nebulab/spree_return_authorizations_frontend'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'solidus_core', '~> 2.1'

  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 3.5'
  s.add_development_dependency 'sass-rails', '~> 5.0'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
