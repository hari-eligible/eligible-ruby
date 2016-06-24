module Eligible
  class Registration < APIResource
    # Create registration. It will post the registration JSON and return policies
    # Params:
    # +params+:: Registration JSON Hash
    # +params+:: API key provided by Eligible
    def self.post(params, api_key = nil)
      send_request(:post, '/registrations.json', api_key, params)
    end
  end
end
