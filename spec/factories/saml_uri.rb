# frozen_string_literal: true

FactoryGirl.define do
  factory :saml_uri do
    uri { "#{Faker::Internet.url}/shibboleth" }
    description { Faker::Lorem.sentence }
  end
end
