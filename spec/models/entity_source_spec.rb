# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EntitySource do
  def pem_jumble(pem)
    parts = pem.split("\n").map do |s|
      next s if s.start_with?('-----', 'MII')
      s.reverse
    end

    parts.join("\n")
  end

  subject { build(:entity_source) }

  it_behaves_like 'a basic model'

  it { is_expected.to validate_presence(:rank) }
  it { is_expected.to validate_integer(:rank) }
  it { is_expected.to validate_unique(:rank) }
  it { is_expected.to validate_presence(:source_tag) }
  it { is_expected.to validate_unique(:source_tag) }
  it { is_expected.to validate_presence(:enabled) }
  it { is_expected.not_to validate_presence(:url) }
  it { is_expected.not_to validate_presence(:certificate) }

  context 'url validation' do
    it 'accepts a nil url' do
      subject.url = nil
      expect(subject).to be_valid
    end

    it 'accepts a valid https url' do
      subject.url = 'https://fed.example.com/metadata/full.xml'
      expect(subject).to be_valid
    end

    it 'accepts a valid http url' do
      subject.url = 'http://fed.example.com/metadata/full.xml'
      expect(subject).to be_valid
    end

    it 'rejects an ftp url' do
      subject.url = 'ftp://fed.example.com/metadata/full.xml'
      expect(subject).not_to be_valid
    end

    it 'rejects a url which does not parse' do
      subject.url = 'https://fed.test example.com/metadata/full.xml'
      expect(subject).not_to be_valid
    end
  end

  context 'certificate validation' do
    it 'accepts a nil certificate' do
      subject.certificate = nil
      expect(subject).to be_valid
    end

    it 'accepts a valid certificate' do
      subject.certificate = valid_cert
      expect(subject).to be_valid
    end

    it 'rejects an invalid certificate' do
      subject.certificate = invalid_cert
      expect(subject).not_to be_valid
    end

    it 'rejects a completely invalid string' do
      subject.certificate = 'hello!'
      expect(subject).not_to be_valid
    end
  end

  context '#x509_certificate' do
    it 'returns nil when certificate is nil' do
      subject.certificate = nil
      expect(subject.x509_certificate).to be_nil
    end

    it 'returns a certificate object' do
      subject.certificate = valid_cert
      expect(subject.x509_certificate).to be_an(OpenSSL::X509::Certificate)
    end
  end

  let(:valid_cert) { create(:certificate).to_pem }
  let(:invalid_cert) { pem_jumble(valid_cert) }
end
