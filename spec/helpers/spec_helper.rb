# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../../init'

USERNAME = 'soumyaray'
PROJECT_NAME = 'YPBT-app'
GH_URL = 'http://github.com/soumyaray/YPBT-app'
GITHUB_TOKEN = CodePraise::App.config.GITHUB_TOKEN
CORRECT = YAML.safe_load(File.read('spec/fixtures/github_results.yml'))

# Helper method for acceptance tests
def homepage
  CodePraise::App.config.APP_HOST
end
