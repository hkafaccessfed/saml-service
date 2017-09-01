# frozen_string_literal: true

class ManageNameIdService < Endpoint
  many_to_one :sso_descriptor
end
