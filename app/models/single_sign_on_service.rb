# frozen_string_literal: true

class SingleSignOnService < Endpoint
  many_to_one :idp_sso_descriptor
end
