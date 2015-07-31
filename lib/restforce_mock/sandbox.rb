module RestforceMock
  module Sandbox

    def self.add_object(name, id, values)
      if storage[name] && !storage[name][id].nil?
        raise "Object #{name} with #{id} exists"
      end
      storage[name].merge!({ id  => values })
    end

    def add_object(name, id, values)
      RestforceMock::Sandbox.add_object(name, id, values)
    end

    def self.update_object(name, id, attrs)
      current = storage[name][id]
      storage[name][id] = current.merge(attrs)
    end

    def update_object(name, id, attrs)
      RestforceMock::Sandbox.update_object(name, id, attrs)
    end

    def self.reset!
      $restforce_mock_storage = initialize
    end

    def self.storage
      $restforce_mock_storage ||= initialize
    end

    #Private
    def self.initialize
      Hash.new do |hash, object|
        hash[object]={}
      end
    end

  end
end
