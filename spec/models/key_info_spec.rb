# frozen_string_literal: true

require 'rails_helper'

describe KeyInfo do
  it_behaves_like 'a basic model'

  it { is_expected.to validate_presence :data }
  it { is_expected.to respond_to :key_name }
  it { is_expected.to respond_to :subject }
  it { is_expected.to respond_to :issuer }
  it { is_expected.to respond_to :expiry }

  context '#data=' do
    subject { (create :key_info) }
    let(:cert) { 'invalid data' }
    it 'only accepts PEM encoded certificate data' do
      expect { subject.data = cert }
        .to raise_error(OpenSSL::X509::CertificateError)
    end
  end

  context '#certifcate' do
    subject { (create :key_info) }
    let(:cert) { subject.certificate }
    it 'provides PEM encoded certificate data' do
      expect { OpenSSL::X509::Certificate.new(cert) }.not_to raise_error
    end
  end

  context '#certificate_without_anchors' do
    subject { (create :key_info) }
    let(:cert) { subject.certificate_without_anchors }
    it 'provides certificate data without anchors' do
      data = subject.certificate
                    .sub('-----BEGIN CERTIFICATE-----', '')
                    .sub('-----END CERTIFICATE-----', '')
                    .strip
      expect(data).to eq(cert)
    end
  end
end
