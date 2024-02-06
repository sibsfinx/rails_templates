gem 'active_link_to'
gem 'anyway_config'
gem 'bootstrap', '~> 5.1.3'
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

end
