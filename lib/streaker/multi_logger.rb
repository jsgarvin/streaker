class MultiLogger
  attr_reader :loggers

  def initialize(*loggers)
    @loggers = loggers
  end

  def method_missing(method_name, *args, &block)
    loggers.each do |logger|
      logger.send(method_name, *args, &block)
    end
  end
end
