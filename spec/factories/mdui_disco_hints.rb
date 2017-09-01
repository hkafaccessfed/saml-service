# frozen_string_literal: true

FactoryGirl.define do
  factory :mdui_disco_hint, class: 'MDUI::DiscoHints' do
    idp_sso_descriptor

    trait :with_content do
      after(:create) do |disco_hint|
        disco_hint.add_ip_hint create :mdui_ip_hint
        disco_hint.add_domain_hint create :mdui_domain_hint
        disco_hint.add_geolocation_hint create :mdui_geolocation_hint
      end
    end
  end
end
