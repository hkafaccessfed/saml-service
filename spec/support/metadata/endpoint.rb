# frozen_string_literal: true

RSpec.shared_examples 'Endpoint xml' do
  it 'is created' do
    expect(xml).to have_xpath(endpoint_path)
  end

  context 'attributes' do
    let(:node) { xml.first(:xpath, endpoint_path) }
    context 'Binding' do
      it 'has expected value' do
        expect(node['Binding']).to eq(endpoint.binding)
      end
    end
    context 'Location' do
      it 'has expected value' do
        expect(node['Location']).to eq(endpoint.location)
      end
    end
    context 'ResponseLocation' do
      context 'when not populated' do
        it 'is not rendered' do
          expect(xml).not_to have_xpath("#{endpoint_path}[@ResponseLocation]")
        end
      end
      context 'when populated' do
        let(:endpoint) { create parent_node, :response_location }
        it 'is rendered' do
          expect(xml).to have_xpath("#{endpoint_path}[@ResponseLocation]")
        end
        it 'has expected value' do
          expect(node['ResponseLocation']).to eq(endpoint.response_location)
        end
      end
    end
  end
end

RSpec.shared_examples 'IndexedEndpoint xml' do
  include_examples 'Endpoint xml'

  context 'attributes' do
    let(:node) { xml.first(:xpath, endpoint_path) }
    context 'index' do
      it 'has expected value' do
        expect(node['index']).to eq(endpoint.index.to_s)
      end
    end

    context 'isDefault' do
      let(:endpoint) { create parent_node, :default_indexed_endpoint }
      it 'is rendered' do
        expect(xml).to have_xpath("#{endpoint_path}[@isDefault]")
      end
      it 'has expected value' do
        expect(node['isDefault']).to eq(endpoint.is_default.to_s)
      end
    end
  end
end
