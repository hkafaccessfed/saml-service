# frozen_string_literal: true

FactoryGirl.define do
  factory :tag do
    sequence :name do |n|
      "#{Faker::Lorem.characters(20)}-#{n}"
    end
    association :known_entity
  end

  factory :known_entity_tag, class: 'Tag' do
    sequence(:name) { |n| "#{Faker::Lorem.characters(20)}-#{n}" }
    association :known_entity
  end
end
