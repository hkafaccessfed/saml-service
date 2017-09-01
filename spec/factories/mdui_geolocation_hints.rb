# frozen_string_literal: true

FactoryGirl.define do
  factory :mdui_geolocation_hint, class: 'MDUI::GeolocationHint' do
    transient { components(2) }

    uri { "geo:#{(1..components).map { Faker::Number.number(3) }.join(',')}" }
    association :disco_hints, factory: :mdui_disco_hint

    trait :with_altitude do
      transient { components(3) }
    end
  end
end
