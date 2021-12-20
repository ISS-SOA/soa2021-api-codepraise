# frozen_string_literal: true

require 'figaro'
require 'roda'
require 'sequel'
require 'delegate' # needed until Rack 2.3 fixes delegateclass bug
require 'rack/cache'
require 'redis-rack-cache'

module CodePraise
  # Environment-specific configuration
  class App < Roda
    plugin :environments

    # Environment variables setup
    Figaro.application = Figaro::Application.new(
      environment: environment,
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config() = Figaro.env

    configure :development, :test , :app_test do
      require 'pry'; # for breakpoints
      ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
    end

    configure :development do
      use Rack::Cache,
          verbose: true,
          metastore: 'file:_cache/rack/meta',
          entitystore: 'file:_cache/rack/body'
    end

    configure :production do
      puts 'RUNNING IN PRODUCTION MODE'
      # Set DATABASE_URL environment variable on production platform

      use Rack::Cache,
          verbose: true,
          metastore: config.REDISCLOUD_URL + '/0/metastore',
          entitystore: config.REDISCLOUD_URL + '/0/entitystore'
    end

    configure :app_test do
      require_relative '../spec/helpers/vcr_helper'
      VcrHelper.setup_vcr
      VcrHelper.configure_vcr_for_github(recording: :none)
    end

    # Database Setup
    DB = Sequel.connect(ENV['DATABASE_URL'])
    # deliberately :reek:UncommunicativeMethodName calling method DB
    def self.DB() = DB # rubocop:disable Naming/MethodName
  end
end
