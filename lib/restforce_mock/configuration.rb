module RestforceMock
  class Configuration
    attr_accessor :schema_file
    attr_writer :error_on_required
    attr_writer :required_exclusions

    def error_on_required
      @error_on_required.nil? ?  true : @error_on_required
    end

    def required_exclusions
      @required_exclusions || default_exclusions
    end

    private

    def default_exclusions
      [
        :Id, :IsDeleted, :Name, :CreatedDate, :CreatedById,
        :LastModifiedDate, :LastModifiedById, :SystemModstamp
      ]
    end
  end
end
