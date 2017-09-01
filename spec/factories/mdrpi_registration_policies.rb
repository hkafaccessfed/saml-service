# frozen_string_literal: true

FactoryGirl.define do
  factory :mdrpi_registration_policy, class: 'MDRPI::RegistrationPolicy',
                                      parent: :localized_uri do
    registration_info factory: :mdrpi_registration_info
  end
end
