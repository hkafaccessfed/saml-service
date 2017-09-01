# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RawEntityDescriptor do
  it_behaves_like 'a basic model'

  it { is_expected.to have_many_to_one(:known_entity) }
  it { is_expected.to validate_presence :entity_id }

  it { is_expected.to validate_presence(:xml) }
  it { is_expected.to validate_max_length(16_777_215, :xml) }
  it { is_expected.to validate_presence(:known_entity) }
  it { is_expected.to validate_unique(:known_entity) }

  it { is_expected.to respond_to(:idp?) }
  it { is_expected.to respond_to(:sp?) }
  it { is_expected.to respond_to(:standalone_aa?) }

  context 'xml validation' do
    subject { build(:raw_entity_descriptor) }

    it 'accepts a valid EntityDescriptor payload' do
      expect(subject).to be_valid
    end

    it 'rejects an EntitiesDescriptor payload' do
      subject.xml =
        '<EntitiesDescriptor xmlns="urn:oasis:names:tc:SAML:2.0:metadata">' \
        "\n#{subject.xml}\n</EntitiesDescriptor>"

      expect(subject).not_to be_valid
      expect(subject.errors[:xml])
        .to contain_exactly('must have <EntityDescriptor> as the root')
    end

    it 'rejects an EntityDescriptor payload with no namespace' do
      subject.xml = subject.xml.sub(/xmlns=".*"/, '')

      expect(subject).not_to be_valid
      expect(subject.errors[:xml])
        .to include(match(/must have SAML 2\.0 metadata namespace/))
    end

    it 'rejects a schema-invalid EntityDescriptor' do
      subject.xml =
        '<EntityDescriptor xmlns="urn:oasis:names:tc:SAML:2.0:metadata"/>'

      expect(subject).not_to be_valid
      expect(subject.errors[:xml])
        .to contain_exactly(match(/is not valid per the XML Schema/))
    end
  end

  describe '#functioning?' do
    subject { create :raw_entity_descriptor }

    context 'when ED is valid' do
      before { subject.enabled = true }

      it 'valid' do
        expect(subject).to be_valid
      end
      it 'is functioning when enabled' do
        expect(subject).to be_functioning
      end
      it 'is not functioning when not enabled' do
        subject.enabled = false
        expect(subject).not_to be_functioning
      end
    end

    context 'when ED is invalid' do
      before do
        subject.enabled = true
        subject.xml = nil
      end

      it 'is not valid' do
        expect(subject).not_to be_valid
      end
      it 'is not functioning when enabled' do
        expect(subject).not_to be_functioning
      end
      it 'is not functioning when not enabled' do
        subject.enabled = false
        expect(subject).not_to be_functioning
      end
    end
  end

  describe '#destroy' do
    subject { create :raw_entity_descriptor }

    it 'is successfully destroyed' do
      expect { subject.destroy }.not_to raise_error
    end
  end

  describe '#ui_info' do
    subject { create :raw_entity_descriptor }

    it 'populates a hash when ui_info xml content present' do
      expect(subject.ui_info).not_to be_nil
    end

    it 'populates MDUI DisplayNames' do
      expect(subject.ui_info.display_names).to be_present
      expect(subject.ui_info.display_names).to all(respond_to(:lang))
        .and all(respond_to(:value))
    end

    it 'populates MDUI Description' do
      expect(subject.ui_info.descriptions).to be_present
      expect(subject.ui_info.descriptions).to all(respond_to(:lang))
        .and all(respond_to(:value))
    end

    it 'populates MDUI Logo' do
      expect(subject.ui_info.logos).to be_present
      expect(subject.ui_info.logos)
        .to all(respond_to(:width))
        .and all(respond_to(:height))
        .and all(respond_to(:uri))
    end

    it 'populates MDUI Information URL' do
      expect(subject.ui_info.information_urls).to be_present
      expect(subject.ui_info.information_urls).to all(respond_to(:lang))
        .and all(respond_to(:uri))
    end

    it 'populates MDUI Privacy Statement URL' do
      expect(subject.ui_info.privacy_statement_urls).to be_present
      expect(subject.ui_info.privacy_statement_urls).to all(respond_to(:lang))
        .and all(respond_to(:uri))
    end
  end

  describe '#disco_hints' do
    subject { create :raw_entity_descriptor }

    it 'populates a hash when disco_hints xml content present' do
      expect(subject.disco_hints).not_to be_nil
    end

    it 'populates IPHints' do
      expect(subject.disco_hints.ip_hints).to be_present
      expect(subject.disco_hints.ip_hints).to all(respond_to(:block))
    end

    it 'populates DomainHints' do
      expect(subject.disco_hints.domain_hints).to be_present
      expect(subject.disco_hints.domain_hints).to all(respond_to(:domain))
    end

    it 'populates GelocationHints' do
      expect(subject.disco_hints.geolocation_hints).to be_present
      expect(subject.disco_hints.geolocation_hints)
        .to all(respond_to(:latitude))
        .and all(respond_to(:longitude))
        .and all(respond_to(:altitude))
    end

    context 'with invalid geolocation uri' do
      subject { create :raw_entity_descriptor_invalid_geo_location }

      it 'ignores invalid geolocation URI values' do
        expect(subject.disco_hints.geolocation_hints.size).to eq(1)
      end
    end
  end

  describe '#discovery_response_services' do
    subject { create :raw_entity_descriptor_sp }

    it 'populates an array when discovery_response xml content present' do
      expect(subject.discovery_response_services).to be_present
      expect(subject.discovery_response_services)
        .to all(respond_to(:location))
        .and all(respond_to(:binding))
        .and all(respond_to(:index))
        .and all(respond_to(:is_default))
    end

    context 'with a missing `isDefault` attribute' do
      subject do
        create(:raw_entity_descriptor_sp).tap do |red|
          red.xml = red.xml.gsub(/isDefault="[^"]+"/, '')
        end
      end

      it 'returns a nil value for `is_default`' do
        expect(subject.discovery_response_services).to be_present
        expect(subject.discovery_response_services)
          .to all(have_attributes(is_default: nil))
      end
    end
  end

  describe '#single_sign_on_services' do
    subject { create :raw_entity_descriptor_idp }

    it 'populates an array when single_sign_on_services xml content present' do
      expect(subject.single_sign_on_services).to be_present
      expect(subject.single_sign_on_services)
        .to all(respond_to(:location))
        .and all(respond_to(:binding))
    end
  end
end
