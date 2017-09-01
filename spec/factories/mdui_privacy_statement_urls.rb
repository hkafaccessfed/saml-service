# frozen_string_literal: true

FactoryGirl.define do
  factory :mdui_privacy_statement_url, class: 'MDUI::PrivacyStatementURL',
                                       parent: :localized_uri do
    association :ui_info, factory: :mdui_ui_info
  end
end
