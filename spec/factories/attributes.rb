FactoryGirl.define do
  factory :_attribute, class: 'Attribute' do
    name { Faker::Lorem.word }

    trait :with_values do
      transient do
        number_of_values 3
      end

      after :create do |attr, eval|
        create_list(:attribute_value, eval.number_of_values, attribute: attr)
      end
    end

    factory :attribute do
      after :create do | a |
        a.name_format = create(:name_format, :uri, attribute: a)
      end
    end

    factory :requested_attribute, class: 'RequestedAttribute' do
      reasoning { Faker::Lorem.sentence }
      required false

      association :attribute_consuming_service
    end
  end
end
