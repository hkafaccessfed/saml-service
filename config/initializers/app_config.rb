# frozen_string_literal: true

Rails.application.configure do
  config.saml_service =
    RecursiveOpenStruct.new(config_for(:saml_service).deep_symbolize_keys)
end
