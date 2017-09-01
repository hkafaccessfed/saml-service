# frozen_string_literal: true

FactoryGirl.define do
  factory :mdui_domain_hint, class: 'MDUI::DomainHint' do
    domain { Faker::Internet.domain_name }
    association :disco_hints, factory: :mdui_disco_hint
  end
end
