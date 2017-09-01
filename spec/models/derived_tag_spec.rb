# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DerivedTag do
  it_behaves_like 'a basic model'

  context 'validations' do
    subject { build(:derived_tag) }

    it { is_expected.to validate_presence(:tag_name) }

    it 'requires when_tags but allows blank' do
      subject.when_tags = ''
      expect(subject).to be_valid

      subject.when_tags = nil
      expect(subject).not_to be_valid
    end

    it 'requires unless_tags but allows blank' do
      subject.unless_tags = ''
      expect(subject).to be_valid

      subject.unless_tags = nil
      expect(subject).not_to be_valid
    end

    it 'permits only a valid tag_name' do
      valid = SecureRandom.urlsafe_base64
      invalid = SecureRandom.urlsafe_base64 + %w[! @ # $ % ^ & * ( ) + =].sample

      subject.tag_name = valid
      expect(subject).to be_valid

      subject.tag_name = invalid
      expect(subject).not_to be_valid
    end

    it 'permits only valid when_tags' do
      valid = 1.upto(10).collect { SecureRandom.urlsafe_base64(6) }.join(',')
      invalid = SecureRandom.urlsafe_base64 + %w[! @ # $ % ^ & * ( ) + =].sample

      subject.when_tags = valid
      expect(subject).to be_valid

      subject.when_tags = invalid
      expect(subject).not_to be_valid
    end

    it 'permits only valid unless_tags' do
      valid = 1.upto(10).collect { SecureRandom.urlsafe_base64(6) }.join(',')
      invalid = SecureRandom.urlsafe_base64 + %w[! @ # $ % ^ & * ( ) + =].sample

      subject.unless_tags = valid
      expect(subject).to be_valid

      subject.unless_tags = invalid
      expect(subject).not_to be_valid
    end
  end
end
