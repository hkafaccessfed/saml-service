# frozen_string_literal: true

require 'openssl'

FactoryGirl.define do
  subject = "CN=#{Faker::Lorem.word}/DC=#{Faker::Lorem.word}"
  issuer = "CN=#{Faker::Lorem.word}/DC=#{Faker::Lorem.word}"

  trait :base_key_info do
    transient do
      certificate do
        create(:certificate, subject_dn: subject, issuer_dn: issuer)
      end
    end

    expiry { certificate.not_after }
    data { certificate.to_pem }
  end

  trait :with_name do
    key_name { Faker::Lorem.word }
  end

  trait :with_subject do
    subject { subject }
  end

  trait :with_issuer do
    issuer { issuer }
  end

  factory :ca_key_info, class: 'CaKeyInfo' do
    base_key_info
    metadata_instance
  end

  factory :key_info do
    base_key_info
  end
end
