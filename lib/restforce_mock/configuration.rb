module RestforceMock
  class Configuration
    attr_accessor :schema_file
  end
end

module RestforceMock
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= RestforceMock::Configuration.new
  end

  def self.reset
    @configuration = RestforceMock::Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
