# frozen_string_literal: true

class AssertionConsumerService < IndexedEndpoint
  many_to_one :sp_sso_descriptor
end
