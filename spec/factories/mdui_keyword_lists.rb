# frozen_string_literal: true

FactoryGirl.define do
  factory :mdui_keyword_list, class: 'MDUI::KeywordList' do
    lang { 'en' }
    association :ui_info, factory: :mdui_ui_info

    factory :mdui_keyword_list_with_content do
      content { generate_keyword_list }
    end
  end
end

def generate_keyword_list
  keyword_list = Faker::Lorem.words(6)
  encoded_keyword = Faker::Lorem.words(4).join('+')
  keyword_list.push(encoded_keyword).join(' ')
end
