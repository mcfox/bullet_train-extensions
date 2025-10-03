# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "bullet_train-extensions"
  spec.version       = "0.1.0"
  spec.authors       = ["Filoo"]
  spec.email         = ["dev@filoo.example"]

  spec.summary       = "Reusable Tailwind UI helpers and view partials for Bullet Train/Rails apps"
  spec.description   = "Provides a Rails Engine exposing Tailwind-based helpers and field/attribute partials (toggle, pre, workflow_state, json, cents)."
  spec.homepage      = "https://example.com/bullet_train-extensions"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,lib}/**/*", "MIT-LICENSE", "README.md"].select { |f| File.file?(f) }
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 6.1"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
end
