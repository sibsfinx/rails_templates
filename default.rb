gem 'active_link_to'
gem 'anyway_config'
gem 'bootstrap', '~> 5.2'
gem 'autoprefixer-rails'
gem 'semver2', github: 'haf/semver'
gem 'slim-rails'
gem 'sassc-rails'
gem 'env-tweaks', github: 'yivo/env-tweaks', branch: 'dependabot/bundler/activesupport-7.0.4.1'
gem 'simple_form'
gem 'strip_attributes'
gem 'draper'
gem 'dotenv', '~> 2.8'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'ransack', '~> 4.0'
gem 'kaminari', '~> 1.2'
gem 'administrate', '~> 0.19.0'
gem 'administrate-field-jsonb', '~> 0.4.6'
gem 'bugsnag'
gem 'non-digest-assets'
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'sidekiq-failures'
gem 'sidekiq-reset_statistics'

gem_group :development do
  gem 'bcrypt_pbkdf'
  gem 'ed25519'
  gem 'guard'
  gem 'terminal-notifier-guard'
  gem 'guard-ctags-bundler'
  gem 'guard-minitest'
  gem 'guard-rails'
  gem 'guard-rubocop'
  gem 'guard-shell'

  gem 'capistrano', require: false
  gem 'capistrano3-puma', github: 'seuros/capistrano-puma', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-db-tasks', require: false, github: 'brandymint/capistrano-db-tasks',
                             branch: 'feature/extra_args_for_dump'
  gem 'capistrano-dotenv', require: false
  gem 'capistrano-dotenv-tasks', require: false
  gem 'capistrano-faster-assets', require: false
  gem 'capistrano-git-with-submodules'
  gem 'capistrano-master-key', require: false, github: 'virgoproz/capistrano-master-key'
  gem 'capistrano-rails', require: false
  gem 'capistrano-rails-console', require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-shell', require: false
  gem 'capistrano-systemd-multiservice', github: 'brandymint/capistrano-systemd-multiservice', require: false
end


gem_group :development, :test do
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rubocop', require: false
  gem 'rubocop-performance'
  gem 'rubocop-capybara'
  gem 'rubocop-rails', require: false
end

# Rubocop
#
file '.rubocop.yml', <<-CODE
require:
  - rubocop-rails
  - rubocop-performance

AllCops:
  Exclude:
    - node_modules/**/*
    - db/**
    - db/migrate/**
    - bin/**
    - vendor/**/*

Layout/LineLength:
  Max: 120

Metrics/BlockLength:
  Exclude:
    - config/**/*

Style/Documentation:
  Enabled: false
CODE

inject_into_file 'config/environments/development.rb', after: 'Rails.application.configure do' do
  <<~RUBY

    config.hosts << ENV.fetch('RAILS_DEVELOPMENT_HOST', 'localhost')
    config.web_console.whiny_requests = false

  RUBY
end

inject_into_file 'config/application.rb', after: 'require_relative "boot"' do
  <<~RUBY

  ENV['RANSACK_FORM_BUILDER'] = '::SimpleForm::FormBuilder'
  RUBY
end

after_bundle do
  generate('simple_form:install', '--bootstrap')
  generate('anyway:install')
  generate('administrate:install')

  run 'bundle exec rubocop --auto-gen-config'
  # run 'bundle exec rubocop --safe-auto-correct'

  run 'bundle exec semver init'

  # Bootstrap & Popper
  ########################################
  append_file "config/importmap.rb", <<~RUBY
    pin "bootstrap", to: "bootstrap.min.js", preload: true
    pin "@popperjs/core", to: "popper.js", preload: true
  RUBY

  append_file "config/initializers/assets.rb", <<~RUBY
    Rails.application.config.assets.precompile += %w(bootstrap.min.js popper.js)
  RUBY

  append_file "app/javascript/application.js", <<~JS
    import "@popperjs/core"
    import "bootstrap"
  JS

  append_file "app/assets/config/manifest.js", <<~JS
    //= link popper.js
    //= link bootstrap.min.js
    //= link administrate/application.css
    //= link administrate/application.js
    //= link administrate-field-jsonb/application.css
    //= link administrate-field-jsonb/application.js
  JS


  # Create database
  rails_command 'db:create'

  # Commit to git
  #
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end

# Gitignore
########################################
append_file ".gitignore", <<~TXT

  # Ignore .env file containing credentials.
  .env*

  # Ignore Mac and Linux file system files
  *.swp
  .DS_Store
TXT

# Generators
########################################
generators = <<~RUBY
  config.generators do |generate|
    generate.assets false
    generate.helper false
    generate.test_framework :test_unit, fixture: false
    generatr.jbuilder false
  end
RUBY

environment generators

# Dotenv
########################################
run "touch '.envrc'"


# Clone files
run 'rm app/views/layouts/application.html.erb'
run 'rm app/assets/stylesheets/application.css'

run 'git clone git@github.com:dapi/rails_templates.git ./tmp/rails_templates'
run 'cp -vr ./tmp/rails_templates/app/* ./app/'
run 'cp -vr ./tmp/rails_templates/config/* ./config/'
run 'cp -vr ./tmp/rails_templates/lib/* ./lib/'
