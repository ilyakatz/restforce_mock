require "restforce"
require "restforce_mock/sandbox"

module RestforceMock
  class Client

    include ::Restforce::Concerns::API
    include RestforceMock::Sandbox

    def api_patch(url, attrs)
      url=~/sobjects\/(.+)\/(.+)/
      object=$1
      id=$2
      validate_schema!(object)
      validate_presence!(object, id)
      update_object(object, id, attrs)
    end

    def api_post(url, attrs)
      url=~/sobjects\/(.+)/
      sobject = $1
      id = SecureRandom.urlsafe_base64(13) #duplicates possible
      validate_schema!(sobject)
      validate_requires!(sobject, attrs)
      add_object(sobject, id, attrs)
      return Body.new(id)
    end

    def validate_requires!(sobject, attrs)
      return unless RestforceMock.configuration.schema_file
      return unless RestforceMock.configuration.error_on_required

      object_schema = schema[sobject]
      required = object_schema.
        select{|k,v|v[:required]}.
        collect{|k,v|k}.
        collect(&:to_sym)

      missing = required - attrs.keys - RestforceMock.configuration.required_exclusions
      if missing.length > 0
        raise Faraday::Error::ResourceNotFound.new(
          "REQUIRED_FIELD_MISSING: Required fields are missing: #{missing}")
      end
    end

    def validate_presence!(object, id)
      unless RestforceMock::Sandbox.storage[object][id]
        msg = "Provided external ID field does not exist or is not accessible: #{id}"
        raise Faraday::Error::ResourceNotFound.new(msg)
      end
    end

    def validate_schema!(object)
      if RestforceMock.configuration.raise_on_schema_missing
        raise RestforceMock::Error.new("No schema for Salesforce object is available") unless schema

        unless schema[object]
          raise RestforceMock::Error.new("No schema for Salesforce object #{object}")
        end
      end
    end

    private

    def schema
      @schema ||=
        begin
          manager = RestforceMock::SchemaManager.new
          manager.load_schema(RestforceMock.configuration.schema_file)
        end
    end

    class Body
      def initialize(id)
        @body = {'id' => id}
      end

      def body
        @body
      end
    end
  end
end
