# frozen_string_literal: true

RSpec.shared_examples 'KeyDescriptor xml' do
  let(:key_descriptor_path) { '/KeyDescriptor' }
  let(:key_info_path) { "#{key_descriptor_path}/ds:KeyInfo" }

  it 'is created' do
    expect(xml).to have_xpath(key_descriptor_path)
  end

  context 'attributes' do
    let(:node) { xml.first(:xpath, key_descriptor_path) }
    context 'use' do
      context 'when not populated' do
        it 'is not rendered' do
          expect(node['use']).to be_falsey
        end
      end
      context 'when populated' do
        context 'for signing' do
          let(:key_descriptor) do
            create(:key_descriptor, :signing)
          end
          it 'is rendered' do
            expect(node['use']).to eq('signing')
          end
        end
        context 'for encryption' do
          let(:key_descriptor) do
            create(:key_descriptor, :encryption)
          end
          it 'is rendered' do
            expect(node['use']).to eq('encryption')
          end
        end
      end
    end
  end

  context 'KeyInfo' do
    it 'is created' do
      expect(xml).to have_xpath(key_info_path)
    end
  end
end
