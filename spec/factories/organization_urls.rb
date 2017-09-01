# frozen_string_literal: true

FactoryGirl.define do
  factory :organization_url, class: 'OrganizationURL',
                             parent: :localized_uri do
    association :organization
  end
end
