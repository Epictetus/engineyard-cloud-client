require 'engineyard-cloud-client/models/api_struct'
require 'engineyard-cloud-client/errors'

module EY
  class CloudClient
    class Keypair < ApiStruct.new(:id, :name, :public_key)

      def self.all(api)
        self.from_array(api, api.get("/keypairs")["keypairs"])
      end

      # Create a Keypair with your SSH public key so that you can access your Instances
      # via SSH
      # If successful, returns new Keypair and EY Cloud will have registered your public key
      # If unsuccessful, raises +EY::CloudClient::RequestFailed+
      #
      # Usage
      # Keypair.create(api,
      #   name:       "laptop",
      #   public_key: "ssh-rsa OTHERKEYPAIR"
      # )
      #
      # NOTE: Syntax above is for Ruby 1.9. In Ruby 1.8, keys must all be strings.
      def self.create(api, attrs = {})
        params = attrs.dup # no default fields
        raise EY::CloudClient::AttributeRequiredError.new("name") unless params["name"]
        raise EY::CloudClient::AttributeRequiredError.new("public_key") unless params["public_key"]
        response = api.post("/keypairs", "keypair" => params)['keypair']
        self.from_hash(api, response)
      end

      def destroy
        api.delete("/keypairs/#{id}")
      end
    end
  end
end
