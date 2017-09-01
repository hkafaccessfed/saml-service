# frozen_string_literal: true

FactoryGirl.define do
  factory :mdui_information_url, class: 'MDUI::InformationURL',
                                 parent: :localized_uri do
    association :ui_info, factory: :mdui_ui_info
  end
end
