# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name        = 'proxmox-api'
  spec.version     = '0.1.0'
  spec.summary     = 'A library to manage Proxmox VE cluster'
  spec.description = 'A library to manage Proxmox VE cluster using APIv2'
  spec.authors     = ['Eugene Lapeko']
  spec.email       = 'eugene@lapeko.info'
  spec.files       = [
    'Gemfile',
    'LICENSE',
    'lib/proxmox_api.rb'
  ]
  spec.test_files = Dir['spec/**/*rb']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.4'

  spec.add_dependency 'json', '~> 2'
  spec.add_dependency 'rest-client', '~> 2.1'

  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rubocop')

  spec.homepage = 'https://github.com/L-Eugene/proxmox-api'
  spec.license = 'MIT'
end
