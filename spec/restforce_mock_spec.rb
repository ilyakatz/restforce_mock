require 'spec_helper'

describe RestforceMock do
  let(:client) { RestforceMock::Client.new }

  describe "#configure" do
    before do
      RestforceMock.reset
    end

    it "set schema file" do
      RestforceMock.configure do |config|
        config.schema_file = "tmp"
      end

      expect( RestforceMock.configuration.schema_file ).to eq "tmp"
    end

    describe "error_on_required" do

      it "set to true" do
        RestforceMock.configure do |config|
          config.error_on_required = true
        end

        expect( RestforceMock.configuration.error_on_required ).to eq true
      end

      it "sets to true by default" do
        expect( RestforceMock.configuration.error_on_required ).to eq true
      end
    end

    it "doesn't set schema file by default" do
      expect( RestforceMock.configuration.schema_file ).to be_nil
    end
  end

  describe "version" do
    it 'has a version number' do
      expect(RestforceMock::VERSION).not_to be nil
    end
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
      values = { Name: "Name here", Location: "Somewhere"}
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

    describe "api_post" do
      it "mock out POST request" do
        values = { Name: "Name here" }
        body = client.api_post("/sobjects/Contact", values)
        id= body.body["id"]

        s = RestforceMock::Sandbox.send(:storage)
        expect(s["Contact"][id]).to eq values
      end

      context "errors on required is enabled" do
        before do
          RestforceMock.configure do |config|
            config.schema_file = "spec/fixtures/required_schema.yml"
          end
        end

        it "validates required fields" do
          values = { Name: "Name here" }
          expect {
            client.api_post("/sobjects/Object__c", values)
          }.to raise_error Faraday::ResourceNotFound,
          /REQUIRED_FIELD_MISSING: Required fields are missing: \[:Id, :Program__c, :Section_Name__c\]/
        end

        it "validates required fields" do
          values = {
            Name: "Name here",
            Id: "1234",
            Program__c: "1234",
            Section_Name__c: "12345"
          }
          client.api_post("/sobjects/Object__c", values)
        end
      end

      context "errors on required are disabled" do
        before do
          RestforceMock.configure do |config|
            config.schema_file = "spec/fixtures/required_schema.yml"
            config.error_on_required = false
          end
        end

        it "doesn't validate required fields" do

          values = { Name: "Name here" }
          expect {
            client.api_post("/sobjects/Object__c", values)
          }.not_to raise_error
        end
      end

    end
  end

end
