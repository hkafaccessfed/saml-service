RSpec.shared_examples 'EntityDescriptor xml' do
  let(:entity_descriptor) { create :entity_descriptor }
  let(:entity_descriptor_path) { '/EntityDescriptor' }
  let(:extensions_path) { "#{entity_descriptor_path}/Extensions" }
  let(:registration_info_path) { "#{extensions_path}/mdrpi:RegistrationInfo" }
  let(:idp_path) { "#{entity_descriptor_path}/IDPSSODescriptor" }
  let(:sp_path) { "#{entity_descriptor_path}/SPSSODescriptor" }
  let(:aad_path) { "#{entity_descriptor_path}/AttributeAuthorityDescriptor" }
  let(:organization_path) { "#{entity_descriptor_path}/Organization" }
  let(:technical_contact_path) do
    "#{entity_descriptor_path}/ContactPerson[@contactType='technical']"
  end

  let(:create_idp) { false }
  let(:create_sp) { false }
  let(:create_aa) { false }

  before do
    if create_idp
      create(:idp_sso_descriptor, entity_descriptor: entity_descriptor)
    end
    if create_sp
      create(:sp_sso_descriptor, entity_descriptor: entity_descriptor)
    end
    if create_aa
      create(:attribute_authority_descriptor,
             entity_descriptor: entity_descriptor)
    end
  end

  RSpec.shared_examples 'md:EntityDescriptor xml' do
    it 'is created' do
      expect(xml).to have_xpath(entity_descriptor_path)
    end

    context 'attributes' do
      let(:node) { xml.find(:xpath, entity_descriptor_path) }
      it 'has correct entityID' do
        expect(node['entityID']).to eq(entity_descriptor.entity_id.uri)
      end
    end

    context 'Extensions' do
      it 'creates RegistrationInfo node' do
        expect(xml).to have_xpath(registration_info_path, count: 1)
      end
    end

    context 'RoleDescriptors' do
      context 'IDPSSODescriptor' do
        let(:create_idp) { true }
        it 'creates IDPSSODescriptor node' do
          expect(xml).to have_xpath(idp_path, count: 1)
        end
      end
      context 'SPSSODescriptor' do
        let(:create_sp) { true }
        it 'creates SPSSODescriptor node' do
          expect(xml).to have_xpath(sp_path, count: 1)
        end
      end
      context 'AttributeAuthorityDescriptor' do
        let(:create_aa) { true }
        it 'creates AttributeAuthorityDescriptor node' do
          expect(xml).to have_xpath(aad_path, count: 1)
        end
      end
      context 'IDPSSODescriptor and AttributeAuthorityDescriptor pairing' do
        let(:create_idp) { true }
        let(:create_aa) { true }
        it 'creates IDPSSODescriptor node' do
          expect(xml).to have_xpath(idp_path, count: 1)
        end
        it 'creates AttributeAuthorityDescriptor node' do
          expect(xml).to have_xpath(aad_path, count: 1)
        end
      end
    end

    it 'creates an Organization' do
      expect(xml).to have_xpath(organization_path, count: 1)
    end
    it 'creates a technical contact' do
      expect(xml).to have_xpath(technical_contact_path, count: 1)
    end
  end

  context 'Root EntityDescriptor' do
    before { subject.root_entity_descriptor(entity_descriptor) }
    include_examples 'md:EntityDescriptor xml'

    context 'attributes' do
      let(:node) { xml.find(:xpath, entity_descriptor_path) }

      around { |example| Timecop.freeze { example.run } }

      it 'sets ID' do
        expect(node['ID']).to eq(subject.instance_id)
          .and start_with(federation_identifier)
      end
      it 'sets validUntil' do
        expect(node['validUntil'])
          .to eq((Time.now.utc + metadata_validity_period).xmlschema)
      end
    end

    context 'Extensions' do
      it 'creates a mdrpi:PublisherInfo' do
        expect(xml).to have_xpath(all_publication_infos, count: 1)
      end
    end
  end

  context 'EntityDescriptor' do
    before { subject.entity_descriptor(entity_descriptor) }
    include_examples 'md:EntityDescriptor xml'

    context 'attributes' do
      let(:node) { xml.find(:xpath, entity_descriptor_path) }

      it 'sets ID' do
        expect(node['ID']).not_to be
      end
      it 'sets validUntil' do
        expect(node['validUntil']).not_to be
      end
    end

    context 'Extensions' do
      it 'does not create mdrpi:PublisherInfo' do
        expect(xml).to have_xpath(all_publication_infos, count: 0)
      end
    end
  end
end
