# frozen_string_literal: true

FactoryGirl.define do
  factory :attribute_authority_descriptor,
          parent: :role_descriptor, class: 'AttributeAuthorityDescriptor' do
    after(:create) do |aad|
      create :attribute_service, attribute_authority_descriptor: aad
    end

    trait :with_disabled_key_descriptor do
      after(:create) do |aad|
        create(:key_descriptor, :encryption, disabled: true,
                                             role_descriptor: aad)
      end
    end

    trait :with_multiple_attribute_services do
      after(:create) do |aad|
        create_list(:attribute_service, 2, attribute_authority_descriptor: aad)
      end
    end

    trait :with_multiple_assertion_id_request_services do
      after(:create) do |aad|
        create_list(:assertion_id_request_service, 2,
                    attribute_authority_descriptor: aad)
      end
    end

    trait :with_multiple_name_id_formats do
      after(:create) do |aad|
        create_list(:name_id_format, 2,
                    attribute_authority_descriptor: aad)
      end
    end

    trait :with_multiple_attribute_profiles do
      after(:create) do |aad|
        create_list(:attribute_profile, 2,
                    attribute_authority_descriptor: aad)
      end
    end

    trait :with_multiple_attributes do
      after(:create) do |aad|
        create_list(:attribute, 2,
                    attribute_authority_descriptor: aad)
      end
    end
  end
end
