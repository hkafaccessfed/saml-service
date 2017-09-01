# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MDUI::Logo, type: :model do
  it_behaves_like 'a basic model'

  it { is_expected.to have_many_to_one :ui_info }
  it { is_expected.to validate_presence :ui_info }
  it { is_expected.to validate_presence :uri }
  it { is_expected.to validate_presence :width }
  it { is_expected.to validate_presence :height }

  subject { create :mdui_logo }
  describe '#width' do
    it 'rejects negative integers' do
      subject.width = -1
      expect(subject).not_to be_valid
    end
    it 'rejects zero integers' do
      subject.width = 0
      expect(subject).not_to be_valid
    end
    it 'rejects nil integers' do
      subject.width = nil
      expect(subject).not_to be_valid
    end
    it 'accepts positive integers' do
      subject.width = 100
      expect(subject).to be_valid
    end
  end

  describe '#height' do
    it 'rejects negative integers' do
      subject.height = -1
      expect(subject).not_to be_valid
    end
    it 'rejects zero integers' do
      subject.height = 0
      expect(subject).not_to be_valid
    end
    it 'rejects nil integers' do
      subject.height = nil
      expect(subject).not_to be_valid
    end
    it 'accepts positive integers' do
      subject.height = 100
      expect(subject).to be_valid
    end
  end

  describe '#uri' do
    it 'rejects invalid URL' do
      subject.lang = 'en'
      subject.uri = 'invalid'
      expect(subject).not_to be_valid
    end

    context 'valid URL formats' do
      it 'supports http' do
        subject.lang = 'en'
        subject.uri = 'http://example.org'
        expect(subject).to be_valid
      end

      it 'supports https' do
        subject.lang = 'en'
        subject.uri = 'https://example.org'
        expect(subject).to be_valid
      end

      it 'allows port number' do
        subject.lang = 'en'
        subject.uri = 'https://example.org:8080'
        expect(subject).to be_valid
      end
    end
  end
end
