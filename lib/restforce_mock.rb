require "restforce_mock/version"
require "restforce"

module RestforceMock
  class Client

    include ::Restforce::Concerns::API

    def initialize
      @storage = Hash.new do |hash, object|
        hash[object]={}
      end
    end

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
      unless storage[object][id]
        raise Faraday::Error::ResourceNotFound.new("Provided external ID field does not exist or is not accessible: #{id}")
      end
    end

    def add_object(name, id, values)
      if @storage[name][id].present?
        raise "Object #{name} with #{id} exists"
      end
      @storage[name].merge!({ id  => values })
    end

    def update_object(name, id, attrs)
      current = @storage[name][id]
      @storage[name][id] = current.merge(attrs)
    end

    def storage
      @storage
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
  # Your code goes here...
end
