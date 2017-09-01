# frozen_string_literal: true

FactoryGirl.define do
  factory :shibmd_scope, class: 'SHIBMD::Scope' do
    association :role_descriptor, factory: :idp_sso_descriptor
    value Faker::Internet.domain_name
    regexp false
  end
end
