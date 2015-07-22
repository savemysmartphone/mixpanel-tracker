Gem::Specification.new do |s|
  s.name         = 'mixpanel-tracker'
  s.version      = '0.0.1'
  s.platform     = Gem::Platform::RUBY
  s.licenses     = ['MIT']
  s.summary      = 'Mixpanel based gem for automatic controller tracking'
  s.homepage     = 'https://github.com/savemysmartphone/mixpanel-tracker'
  s.description  = 'Yoddo yoddo'
  s.authors      = ['Claouis', "Arnaud 'red' Rouyer"]

  s.files        = `git ls-files`.split("\n")
  s.require_path = 'lib'
  s.required_ruby_version = '>= 2.0.0'

  s.add_runtime_dependency 'mixpanel-ruby'
  s.add_runtime_dependency 'configurations'
end
