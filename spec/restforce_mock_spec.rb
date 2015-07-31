require 'spec_helper'

describe RestforceMock do
  let(:client) { RestforceMock::Client.new }
  it 'has a version number' do
    expect(RestforceMock::VERSION).not_to be nil
  end

  context do
    before do
      RestforceMock::Sandbox.reset!
    end

    after do
      RestforceMock::Sandbox.reset!
    end

    it 'should add object to sandbox though client' do
      name = "Contact"
      id = "some id"
      values = { Name: "Name here" }
      RestforceMock::Client.new.add_object(name, id, values)

      s = RestforceMock::Sandbox.send(:storage)
      expect(s[name][id]).to eq values
    end

    it 'should update values in sandbox' do
      name = "Contact"
      id = "some id"
      values = { Name: "Name here" }
      RestforceMock::Client.new.add_object(name, id, values)
      RestforceMock::Sandbox.update_object(name, id, { Location: "None" })

      s = RestforceMock::Sandbox.send(:storage)
      expect(s[name][id]).to eq values.merge( Location: "None" )
    end

    describe "validate_presence!" do
      it "should validate presence" do
        name = "Contact"
        id = "some id"
        values = { Name: "Name here" }

        client.add_object(name, id, values)
        client.validate_presence!(name, id)
      end

      it "should throw an exception if id is not present" do
        name = "Contact"
        id = "some id"
        values = { Name: "Name here" }

        expect {
          client.validate_presence!(name, id)
        }.to raise_error Faraday::ResourceNotFound, /Provided external ID field does not/
      end
    end
  end

end
