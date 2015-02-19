RSpec.shared_examples 'mdrpi:PublisherInfo xml' do
  context 'MDRPI Publisher Info' do
    let(:publication_info_path) { '/mdrpi:PublicationInfo' }
    let(:usage_policy_path) { "#{publication_info_path}/mdrpi:UsagePolicy" }

    context 'PublisherInfo' do
      it 'is created' do
        expect(xml).to have_xpath(publication_info_path, count: 1)
      end
      context 'attributes' do
        let(:node) { xml.find(:xpath, publication_info_path) }
        it 'sets publisher' do
          expect(node['publisher'])
            .to eq(root_node.publication_info.publisher)
        end
        it 'sets creationInstant' do
          expect(node['creationInstant'])
            .to eq(subject.created_at.xmlschema)
        end
        it 'sets publicationId' do
          expect(node['publicationId']).to eq(subject.instance_id)
            .and start_with(federation_identifier)
        end
      end
      context 'UsagePolicy' do
        it 'is created' do
          expect(xml).to have_xpath(usage_policy_path, count: 1)
        end
        context 'attributes' do
          let(:node) { xml.first(:xpath, usage_policy_path) }
          it 'sets lang' do
            expect(node['xml:lang'])
              .to eq(root_node.publication_info
                     .usage_policies.first.lang)
          end
        end
        context 'value' do
          let(:node) { xml.first(:xpath, usage_policy_path) }
          it 'stores expected URL' do
            expect(node.text).to eq(root_node.publication_info
                                    .usage_policies.first.uri)
          end
        end
      end
    end
  end
end
