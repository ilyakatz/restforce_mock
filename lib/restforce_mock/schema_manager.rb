begin
  require "yaml"
rescue LoadError
end

module RestforceMock
  class SchemaManager

    def initialize(client = default_client  )
      @client = client
    end

    def default_client
      ::Restforce.new
    end

    # Get schema for Salesforce Object
    #
    # object_name - String
    #
    # Returns
    #
    # Hash
    def get_schema(object_name)
      s = @client.describe(object_name)
      object_schema = {}
      s["fields"].each do |field|
        object_schema[field["name"]]= {
          type: field["type"],
          # http://salesforce.stackexchange.com/questions/25233/is-there-a-way-to-find-required-fields-on-an-objects
          required: field["createable"] && !field["nillable"] && !field["defaultedOnCreate"]
        }
      end
      object_schema
    end

    # Dump schema into file
    #
    # object_names - Array[String] array of name of objects in SF
    # file - String yml file
    def dump_schema(object_names, file)
      schema = {}
      object_names.each do |o|
        schema[o] = get_schema(o)
      end
      File.open(file, 'w') {|f| f.write schema.to_yaml }
    end

    def load_schema(file)
      if file.nil?
        raise "Schema file is not defined"
      end
      thing = YAML.load_file(file)
    end

  end
end
