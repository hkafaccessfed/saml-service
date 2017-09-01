# frozen_string_literal: true

FactoryGirl.define do
  factory :additional_metadata_location do
    uri { Faker::Internet.url }
    namespace { "urn:mace:example:#{Faker::Lorem.word}:#{Faker::Lorem.word}" }

    association :entity_descriptor
  end
end
