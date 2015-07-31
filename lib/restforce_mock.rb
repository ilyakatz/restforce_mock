require "restforce_mock/version"
require "restforce_mock/sandbox"
require "restforce"

module RestforceMock
  class Client

    include ::Restforce::Concerns::API
    include RestforceMock::Sandbox

    def api_patch(url, attrs)
      url=~/sobjects\/(.+)\/(.+)/
      object=$1
      id=$2
      validate_presence!(object, id)
      update_object(object, id, attrs)
    end

    def api_post(url, attrs)
      url=~/sobjects\/(.+)/
      sobject = $1
      id = SecureRandom.urlsafe_base64(13) #duplicates possible
      add_object(sobject, id, attrs)
      return Body.new(id)
    end

    def validate_presence!(object, id)
      unless RestforceMock::Sandbox.storage[object][id]
        raise Faraday::Error::ResourceNotFound.new("Provided external ID field does not exist or is not accessible: #{id}")
      end
    end

    private

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
