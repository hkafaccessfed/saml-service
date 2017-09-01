# frozen_string_literal: true

class DiscoveryResponseService < IndexedEndpoint
  many_to_one :sp_sso_descriptor
end
