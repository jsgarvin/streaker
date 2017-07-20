DAYS_IN_A_MONTH = 30
DAYS_IN_A_QUARTER = 91
DAYS_IN_A_YEAR = 365
DAYS_IN_THREE_YEARS = DAYS_IN_A_YEAR * 3
DAYS_IN_FIVE_YEARS = DAYS_IN_A_YEAR * 5
WEEKS_IN_A_MONTH = 4
WEEKS_IN_A_QUARTER = 13
WEEKS_IN_A_YEAR = 52
WEEKS_IN_THREE_YEARS = WEEKS_IN_A_YEAR * 3
WEEKS_IN_FIVE_YEARS = WEEKS_IN_A_YEAR * 5

module Streaker
  def self.config
    @config ||= OpenStruct.new
  end

  def self.logger
    config.logger ? multi_logger : default_logger
  end

  def self.root
    @root ||= File.expand_path('../../', __FILE__)
  end

  private_class_method

  def self.multi_logger
    @multi_logger ||= MultiLogger.new(default_logger, config.logger)
  end

  def self.default_logger
    @default_logger ||= Logger.new(default_log_file)
  end

  def self.default_log_file
    @default_log_file ||= File.open(default_log_file_path, 'a').tap do |file|
      file.sync = true
    end
  end

  def self.default_log_file_path
    File.expand_path("#{root}/log/#{config.env}.log", __FILE__)
  end
end
