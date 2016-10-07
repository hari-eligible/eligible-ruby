module Eligible
  class SessionToken < APIResource
    # Create session token.
    # Params:
    # +api_key+:: API key provided by Eligible
    # +params+:: Session Token creation params Hash
    #   endpoints: List of requied endpoints
    #   ttl_seconds: Life time of token in seconds(Max 3600)
    #   max_calls: Max number of usage calls allowed by token
    #   user_metadata: Metadata
    def self.create(params, api_key = nil)
      send_request(:post, '/session_tokens/create.json', api_key, params)
    end

    # Revoke a token.
    # Params:
    # +api_key+:: API key provided by Eligible
    # +params+:: Session Token creation params Hash
    #   eligible_id: Eligible ID of a token
    def self.revoke(params, api_key = nil)
      send_request(:post, '/session_tokens/revoke.json', api_key, params)
    end
  end
end
