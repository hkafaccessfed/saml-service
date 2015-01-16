require 'rails_helper'

RSpec.shared_examples 'SAML namespaces' do
  context 'SAML namespaces' do
    it { is_expected.to be_a_kind_of Metadata::SAMLNamespaces }

    it { is_expected.to respond_to(:root) }
    it { is_expected.to respond_to(:saml) }
    it { is_expected.to respond_to(:idpdisc) }
    it { is_expected.to respond_to(:mdrpi) }
    it { is_expected.to respond_to(:mdui) }
    it { is_expected.to respond_to(:mdattr) }
    it { is_expected.to respond_to(:shibmd) }
    it { is_expected.to respond_to(:ds) }
    it { is_expected.to respond_to(:ns) }

    it 'has 9 namespaces defined' do
      expect(subject.ns.size).to eq(9)
    end

    let(:ns) { subject.ns }
    it 'supports SAML 2.0 metadata' do
      expect(ns['xmlns']).to eq('urn:oasis:names:tc:SAML:2.0:metadata')
    end
    it 'supports SAML 2.0 assertion' do
      expect(ns['xmlns:saml']).to eq('urn:oasis:names:tc:SAML:2.0:assertion')
    end
    it 'supports SAML SSO IdP discovery profile' do
      expect(ns['xmlns:idpdisc'])
        .to eq('urn:oasis:names:tc:SAML:profiles:SSO:idp-discovery-protocol')
    end
    it 'supports SAML Metadata RPI' do
      expect(ns['xmlns:mdrpi']).to eq('urn:oasis:names:tc:SAML:metadata:rpi')
    end
    it 'supports SAML Metadata UI' do
      expect(ns['xmlns:mdui']).to eq('urn:oasis:names:tc:SAML:metadata:ui')
    end
    it 'supports SAML Metadata Attributes' do
      expect(ns['xmlns:mdattr'])
        .to eq('urn:oasis:names:tc:SAML:metadata:attribute')
    end
    it 'supports Shibboleth 1.0 Metadata' do
      expect(ns['xmlns:shibmd']).to eq('urn:mace:shibboleth:metadata:1.0')
    end
    it 'supports XML DSig' do
      expect(ns['xmlns:ds']).to eq('http://www.w3.org/2000/09/xmldsig#')
    end
    it 'supports SAML 2.0 assertion' do
      expect(ns['xmlns:saml']).to eq('urn:oasis:names:tc:SAML:2.0:assertion')
    end
  end
end
