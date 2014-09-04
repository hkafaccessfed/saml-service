FactoryGirl.define do
  factory :attribute do
    association :attribute_base, factory: :attribute_basis

    trait :with_values do
      ignore do
        number_of_values 3
      end

      after :create do |attr, eval|
        create_list(:attribute_value, eval.number_of_values, attribute: attr)
      end
    end

    to_create { |i| i.save }
  end
end