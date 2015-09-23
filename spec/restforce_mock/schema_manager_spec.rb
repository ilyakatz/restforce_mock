require 'spec_helper'

describe RestforceMock::SchemaManager do
  describe "#load_schema" do
    it "throws an error if file is not configured" do
      expect {
        RestforceMock::SchemaManager.new.load_schema(nil)
      }.to raise_error("Schema file is not defined")
    end

    it "cannot load file" do
      expect {
        RestforceMock::SchemaManager.new.load_schema("tmp")
      }.to raise_error(Errno::ENOENT)
    end

    it "loads file" do
      location = "#{File.dirname(__FILE__)}/../fixtures/schema.yml"
      s = RestforceMock::SchemaManager.new.load_schema(location)
      expect(s["Contact"]["Id"]).to eq({:type=>"id", :required=>false})
      expect(s["Contact"]["IsDeleted"]).to eq({
        :type=>"boolean", :required=>false
      })
      expect(s["Contact"]["MasterRecordId"]).to eq({
        :type=>"reference", :required=>true
      })
      expect(s["Contact"]["AccountId"]).to eq({
        :type=>"reference", :required=>true
      })
      expect(s["Contact"]["FirstName"]).to eq({
        :type=>"string", :required=>true
      })
    end
  end
end
