source 'https://rubygems.org'

gem 'activerecord'
gem 'activesupport'
gem 'admit_one'
gem 'http'
gem 'mechanize'
gem 'rake'
gem 'remote_syslog_logger'
gem 'strava-api-v3'
gem 'sqlite3'

group :development do
  gem 'rubocop', require: false
end

group :test do
  gem 'coveralls', require: false
  gem 'rspec'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'factory_girl'
  gem 'database_cleaner'
end

group :development, :test do
  gem 'pry'
  gem 'pry-byebug'
  gem 'activerecord_sane_schema_dumper'
end
