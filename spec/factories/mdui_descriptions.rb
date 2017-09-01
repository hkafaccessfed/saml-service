# frozen_string_literal: true

FactoryGirl.define do
  factory :mdui_description, class: 'MDUI::Description',
                             parent: :localized_name do
    association :ui_info, factory: :mdui_ui_info
  end
end
