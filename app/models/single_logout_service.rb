# frozen_string_literal: true

class SingleLogoutService < Endpoint
  many_to_one :sso_descriptor
end
