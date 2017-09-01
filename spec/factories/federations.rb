# frozen_string_literal: true

FactoryGirl.define do
  factory :basic_federation, parent: :entity_source do
    after :create do |es|
      create_list(:basic_federation_entity, 2, :idp, entity_source: es)
      create_list(:basic_federation_entity, 2, :sp, entity_source: es)
      create(:basic_federation_entity, :aa, entity_source: es)
    end
  end

  factory :basic_federation_entity, parent: :known_entity do
    association :entity_source

    trait :idp do
      after(:create) do |entity|
        ed = create(:entity_descriptor,
                    :with_entity_attribute,
                    known_entity: entity)

        create(:idp_sso_descriptor, :with_ui_info,
               entity_descriptor: ed)

        create(:attribute_authority_descriptor,
               entity_descriptor: ed)
      end
    end

    trait :sp do
      after(:create) do |entity|
        ed = create(:entity_descriptor,
                    :with_refeds_rs_entity_category,
                    known_entity: entity)

        create(:sp_sso_descriptor, :request_attributes, :with_ui_info,
               entity_descriptor: ed)
      end
    end

    trait :aa do
      after(:create) do |entity|
        ed = create(:entity_descriptor,
                    :with_entity_attribute,
                    known_entity: entity)

        create(:attribute_authority_descriptor,
               entity_descriptor: ed)
      end
    end
  end
end
