# frozen_string_literal: true

FactoryGirl.define do
  factory :mdui_ip_hint, class: 'MDUI::IPHint' do
    block { "#{Faker::Internet.ip_v4_address}/32" }
    association :disco_hints, factory: :mdui_disco_hint
  end
end
