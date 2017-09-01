# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MDUI::KeywordList, type: :model do
  it_behaves_like 'a basic model'

  it { is_expected.to have_many_to_one :ui_info }
  it { is_expected.to validate_presence :ui_info }
  it { is_expected.to validate_presence :lang }

  describe '#add' do
    subject { create :mdui_keyword_list }

    context 'first keyword' do
      it 'adds new keyword' do
        keyword = Faker::Lorem.word
        expect { subject.add keyword }.to \
          change { subject.content }.to eq keyword
      end

      it 'encodes space as +' do
        keyword_p1 = Faker::Lorem.word
        keyword_p2 = Faker::Lorem.word

        expect { subject.add "#{keyword_p1} #{keyword_p2}" }.to \
          change { subject.content }.to eq "#{keyword_p1}+#{keyword_p2}"
      end
    end

    context 'subsequent keywords' do
      it 'adds new keyword' do
        content = Faker::Lorem.sentence
        subject.content = content
        keyword = Faker::Lorem.word

        expect { subject.add keyword }.to change { subject.content }.to \
          eq "#{content} #{keyword}"
      end

      it 'encodes space as +' do
        content = Faker::Lorem.sentence
        subject.content = content
        keyword_p1 = Faker::Lorem.word
        keyword_p2 = Faker::Lorem.word

        expect { subject.add "#{keyword_p1} #{keyword_p2}" }.to \
          change { subject.content }.to \
            eq "#{content} #{keyword_p1}+#{keyword_p2}"
      end
    end
  end

  describe '#to_xml_list' do
    it 'provides keywords as string' do
      keywords = Faker::Lorem.sentence
      subject.content = keywords
      expect(subject.to_xml_list).to eq keywords
    end

    it 'provides keywords that are encoded' do
      keywords = "#{Faker::Lorem.sentence} " \
                 "#{Faker::Lorem.word}+#{Faker::Lorem.word} " \
                 "#{Faker::Lorem.sentence}"
      subject.content = keywords
      expect(subject.to_xml_list).to eq keywords
    end
  end
end
