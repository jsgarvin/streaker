require 'bundler/setup'
require 'yaml'
require 'active_record'
require 'remote_syslog_logger'
require 'logger'
require 'pry'
require 'date'
require 'http'
require 'ostruct'
require 'erb'

Dir.glob(File.expand_path('../../lib/**/*.rb', __FILE__))
   .each { |file| require file }

Streaker.config.env = ENV['STREAKER_ENV'] || 'development'
require_relative '../config/streaker.rb' unless Streaker.config.env == 'test'

db_file = File.expand_path('../database.yml', __FILE__)
db_config = YAML.load_file(db_file)[Streaker.config.env]
ActiveRecord::Base.establish_connection(db_config)
