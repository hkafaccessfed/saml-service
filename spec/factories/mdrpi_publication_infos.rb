# frozen_string_literal: true

FactoryGirl.define do
  factory :mdrpi_publication_info, class: 'MDRPI::PublicationInfo' do
    publisher { Faker::Internet.url }

    after(:create) do |pi|
      pi.add_usage_policy(create(:mdrpi_usage_policy, publication_info: pi))
    end
  end
end
