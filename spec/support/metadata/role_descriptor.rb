# frozen_string_literal: true

RSpec.shared_examples 'RoleDescriptor xml' do
  let(:extensions_path) { "#{role_descriptor_path}/Extensions" }
  let(:test_extensions_path) { "#{extensions_path}/some-node" }
  let(:mdui_ui_info_path) { "#{role_descriptor_path}/Extensions/mdui:UIInfo" }
  let(:shibmd_scope_path) { "#{role_descriptor_path}/Extensions/shibmd:Scope" }
  let(:key_descriptors_path) { "#{role_descriptor_path}/KeyDescriptor" }
  let(:organization_path) { "#{role_descriptor_path}/Organization" }
  let(:contacts_path) { "#{role_descriptor_path}/ContactPerson" }

  let(:node) { xml.first(:xpath, role_descriptor_path) }

  it 'is created' do
    expect(xml).to have_xpath(role_descriptor_path)
  end

  context 'attributes' do
    context 'protocol supports' do
      it 'is rendered' do
        expect(role_descriptor.protocol_supports.length).to eq(2)
        expect(node['protocolSupportEnumeration'])
          .to eq(role_descriptor.protocol_supports.map(&:uri).join(' '))
      end
    end
    context 'error URL' do
      context 'when not populated' do
        it 'is not rendered' do
          expect(node['errorURL']).to be_falsey
        end
      end
      context 'when populated' do
        let(:role_descriptor) do
          create parent_node, :with_error_url
        end
        it 'is rendered' do
          expect(node['errorURL']).to eq(role_descriptor.error_url)
        end
      end
    end
  end

  context 'Extensions' do
    context 'when not populated' do
      it 'is not rendered' do
        expect(xml).not_to have_xpath(extensions_path)
      end
    end
    context 'when populated' do
      let(:node) { xml.first(:xpath, extensions_path) }
      let(:role_descriptor) do
        create parent_node, :with_extensions
      end
      it 'is rendered' do
        expect(node).to have_xpath(test_extensions_path)
      end
    end
  end

  context 'KeyDescriptors' do
    context 'when populated' do
      let(:role_descriptor) { create parent_node, :with_key_descriptors }
      it 'is rendered' do
        expect(xml).to have_xpath(key_descriptors_path, count: 2)
      end

      context 'with disabled keys' do
        let(:role_descriptor) do
          create parent_node, :with_key_descriptors,
                 :with_disabled_key_descriptor
        end

        it 'has 3 key_descriptors' do
          expect(role_descriptor.key_descriptors.count).to eq(3)
        end

        it 'has a disabled key_descriptor' do
          disabled_kd = role_descriptor.key_descriptors.find_all(&:disabled)
          expect(disabled_kd.count).to eq(1)
        end

        it 'is rendered' do
          expect(xml).to have_xpath(key_descriptors_path, count: 2)
        end
      end
    end
    context 'when not populated' do
      it 'is not rendered' do
        expect(xml).not_to have_xpath(key_descriptors_path)
      end
    end
  end

  context 'Organization' do
    it 'is not rendered' do
      expect(xml).not_to have_xpath(organization_path)
    end
  end

  context 'Contacts' do
    context 'when populated' do
      let(:role_descriptor) { create parent_node, :with_contacts }
      it 'is rendered when present' do
        expect(xml).to have_xpath(contacts_path, count: 2)
      end
    end
    context 'when not populated' do
      it 'is not rendered' do
        expect(xml).not_to have_xpath(contacts_path)
      end
    end
  end

  context 'mdui:UIInfo' do
    context 'when not populated' do
      it 'is not rendered' do
        expect(xml).not_to have_xpath(mdui_ui_info_path)
      end
    end
    context 'when populated' do
      let(:role_descriptor) { create parent_node, :with_ui_info }
      it 'is rendered' do
        expect(xml).to have_xpath(mdui_ui_info_path)
      end
    end
  end

  context 'shibmd:Scope' do
    context 'when not populated' do
      it 'is not rendered' do
        expect(xml).not_to have_xpath(shibmd_scope_path)
      end
    end
    context 'when populated' do
      let(:role_descriptor) { create parent_node, :with_scopes }
      it 'is rendered' do
        expect(xml).to have_xpath(shibmd_scope_path, count: 2)
      end
    end
  end
end
