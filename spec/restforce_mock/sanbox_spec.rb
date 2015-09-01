require 'spec_helper'

describe RestforceMock::Sandbox do
  context do
    before do
      RestforceMock::Sandbox.reset!
    end

    after do
      RestforceMock::Sandbox.reset!
    end

    it 'should add object to sandbox storage' do
      name = "Contact"
      id = "some id"
      values = { Name: "Name here" }
      RestforceMock::Sandbox.add_object(name, id, values)

      s = RestforceMock::Sandbox.send(:storage)
      expect(s[name][id]).to eq values
    end

    it 'should update values in sandbox' do
      name = "Contact"
      id = "some id"
      values = { Name: "Name here", Location: "Somewhere"}
      RestforceMock::Sandbox.add_object(name, id, values)
      RestforceMock::Sandbox.update_object(name, id, { Location: "None" })

      s = RestforceMock::Sandbox.send(:storage)
      expect(s[name][id]).to eq values.merge( Location: "None" )
    end

    it 'should throw an error for field that doesn not exist' do
      name = "Contact"
      id = "some id"
      values = { Name: "Name here"}
      RestforceMock::Sandbox.add_object(name, id, values)
      expect {
        RestforceMock::Sandbox.update_object(name, id, { Location: "None" })
      }.to raise_error(Faraday::ResourceNotFound,
                       /INVALID_FIELD_FOR_INSERT_UPDATE.*Location/)
    end
  end

  it 'should reset the sandbox' do
    name = "Contact"
    id = "some id"
    values = { Name: "Name here" }
    RestforceMock::Sandbox.add_object(name, id, values)

    RestforceMock::Sandbox.reset!

    s = RestforceMock::Sandbox.send(:storage)
    expect(s).to eq ({})
  end
end
