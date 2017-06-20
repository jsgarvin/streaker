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
