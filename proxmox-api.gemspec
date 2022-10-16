# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name        = 'proxmox-api'
  spec.version     = '1.1.0'
  spec.summary     = 'Proxmox VE REST API wrapper'
  spec.description = 'Proxmox VE REST API wrapper'
  spec.authors     = ['Eugene Lapeko']
  spec.email       = 'eugene@lapeko.info'
  spec.files       = [
    'Gemfile',
    'LICENSE',
    'lib/proxmox_api.rb'
  ]
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.5'

  spec.add_dependency 'json', '~> 2'
  spec.add_dependency 'rest-client', '~> 2.1'

  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rubocop')

  spec.homepage = 'https://github.com/L-Eugene/proxmox-api'
  spec.license = 'MIT'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
