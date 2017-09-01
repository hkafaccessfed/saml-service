# frozen_string_literal: true

FactoryGirl.define do
  factory :federation_registry_source do
    association :entity_source

    registration_authority { Faker::Internet.url }
    registration_policy_uri { Faker::Internet.url }
    registration_policy_uri_lang { 'en' }

    hostname { "manager.#{Faker::Internet.domain_name}" }
    secret { SecureRandom.urlsafe_base64 }
  end
end
