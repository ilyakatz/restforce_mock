module RestforceMock
  class Configuration
    attr_accessor :schema_file
    attr_writer :error_on_required

    def error_on_required
      @error_on_required || true
    end
  end
end
