# frozen_string_literal: true

FactoryGirl.define do
  factory :derived_tag do
    tag_name { Faker::Lorem.word }
    when_tags { Faker::Lorem.words.join(',') }
    unless_tags do
      when_tag_names = when_tags.split(',')

      (1..100).lazy
              .map { Faker::Lorem.word }
              .reject { |w| when_tag_names.include?(w) }
              .take(5)
              .to_a
              .join(',')
    end
  end
end
