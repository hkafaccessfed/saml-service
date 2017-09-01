# frozen_string_literal: true

FactoryGirl.define do
  factory :mdui_display_name, class: 'MDUI::DisplayName',
                              parent: :localized_name do
    association :ui_info, factory: :mdui_ui_info
  end
end
