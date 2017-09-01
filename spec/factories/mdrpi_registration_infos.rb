# frozen_string_literal: true

FactoryGirl.define do
  factory :mdrpi_registration_info, class: 'MDRPI::RegistrationInfo' do
    registration_authority { Faker::Internet.url }

    after(:create) do |ri|
      ri.add_registration_policy create :mdrpi_registration_policy,
                                        registration_info: ri
    end
  end
end
