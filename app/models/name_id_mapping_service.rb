# frozen_string_literal: true

class NameIdMappingService < Endpoint
  many_to_one :idp_sso_descriptor
end
