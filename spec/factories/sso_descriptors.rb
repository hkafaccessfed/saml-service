# frozen_string_literal: true

FactoryGirl.define do
  factory :sso_descriptor, class: 'SSODescriptor', parent: :role_descriptor do
    trait :with_artifact_resolution_service do
      after(:create) do |sso|
        create(:artifact_resolution_service, sso_descriptor: sso)
      end
    end
    trait :with_artifact_resolution_services do
      after(:create) do |sso|
        create_list(:artifact_resolution_service, 2, sso_descriptor: sso)
      end
    end

    trait :with_single_logout_service do
      after(:create) do |sso|
        create(:single_logout_service, sso_descriptor: sso)
      end
    end
    trait :with_single_logout_services do
      after(:create) do |sso|
        create_list(:single_logout_service, 2, sso_descriptor: sso)
      end
    end

    trait :with_manage_name_id_service do
      after(:create) do |sso|
        create(:manage_name_id_service, sso_descriptor: sso)
      end
    end
    trait :with_manage_name_id_services do
      after(:create) do |sso|
        create_list(:manage_name_id_service, 2, sso_descriptor: sso)
      end
    end

    trait :with_name_id_format do
      after(:create) do |sso|
        create(:name_id_format, sso_descriptor: sso)
      end
    end
    trait :with_name_id_formats do
      after(:create) do |sso|
        create_list(:name_id_format, 2, sso_descriptor: sso)
      end
    end
  end
end
