# frozen_string_literal: true

# Base class for application config classes
class ApplicationConfig < Anyway::Config
  attr_config(
    app_title: 'ChangeMe',
    host: 'localhost',
    protocol: 'http',
    sidekiq_redis_url: 'redis://localhost:6379/0',
  )

  class << self
    # Make it possible to access a singleton config instance
    # via class methods (i.e., without explicitly calling `instance`)
    delegate_missing_to :instance

    def url
      protocol + '://' + host
    end

    private

    # Returns a singleton config instance
    def instance
      @instance ||= new
    end
  end
end
