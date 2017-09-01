# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MetadataQueryController, type: :controller do
  let(:caching_klass) { Class.new { include MetadataQueryCaching } }
  let(:caching) { caching_klass.new }

  around { |example| Timecop.freeze { example.run } }

  RSpec.shared_examples 'invalid requests' do
    subject { response }

    context 'with invalid content_type' do
      before do
        request.accept = 'text/plain'
        query
      end

      it { is_expected.to have_http_status(:not_acceptable) }
    end

    context 'with invalid charset' do
      before do
        request.accept = saml_content
        request.headers['Accept-Charset'] = 'utf-16'
        query
      end

      it { is_expected.to have_http_status(:not_acceptable) }
    end

    context 'with invalid instance identifier' do
      let(:instance_identifier) { Faker::Lorem.word }
      let!(:metadata_instance) { nil }

      before do
        request.accept = saml_content
        query
      end

      it { is_expected.to have_http_status(:not_found) }
      it 'has relevant MUST/SHOULD headers per specification' do
        expect(subject.headers['Cache-Control']).to eq('max-age=600, private')
      end
    end
  end

  RSpec.shared_examples 'non get request' do
    context 'POST, PATCH, DELETE etc' do
      subject { response }
      before do
        query
      end

      it { is_expected.to have_http_status(:method_not_allowed) }
    end
  end

  RSpec.shared_examples '200 response' do
    it { is_expected.to have_http_status(:ok) }

    context 'headers' do
      it 'has relevant MUST/SHOULD headers per specification' do
        cache_period = metadata_instance.cache_period

        expected = {
          'Content-Type' => "#{saml_content}; charset=utf-8",
          'ETag' => etag,
          'Cache-Control' => "max-age=#{cache_period}, private"
        }

        expected.each do |k, v|
          expect(subject.headers[k]).to eq(v)
        end
      end
    end
  end

  RSpec.shared_examples 'entity descriptor response' do
    context 'response body' do
      subject { Capybara::Node::Simple.new(Nokogiri::XML.parse(response.body)) }

      it 'Has a root EntityDescriptor element' do
        expect(subject).to have_xpath('/xmlns:EntityDescriptor')
      end

      it 'Has a signature element' do
        expect(subject
          .first(:xpath,
                 '/xmlns:EntityDescriptor/ds:Signature/ds:SignatureValue')
          .text)
          .not_to be_empty
      end
    end
  end

  RSpec.shared_examples 'entities descriptor response' do
    context 'response body' do
      subject { Capybara::Node::Simple.new(Nokogiri::XML.parse(response.body)) }

      it 'Has a root EntityDescriptor element' do
        expect(subject).to have_xpath('/xmlns:EntitiesDescriptor')
      end

      it 'Has a signature element' do
        expect(subject
          .first(:xpath,
                 '/xmlns:EntitiesDescriptor/ds:Signature/ds:SignatureValue')
          .text)
          .not_to be_empty
      end
    end
  end

  before(:each) do
    Rails.cache.clear
  end

  let(:saml_content) { MetadataQueryController::SAML_CONTENT_TYPE }
  let(:instance_identifier) { metadata_instance.identifier }
  let(:primary_tag) { Faker::Lorem.word }

  let!(:metadata_instance) do
    create :metadata_instance, primary_tag: primary_tag
  end

  describe '#all_entities' do
    context 'GET' do
      context 'valid client request' do
        context 'MetadataInstance does not allow rendering all entities' do
          let!(:metadata_instance) do
            create :metadata_instance, primary_tag: primary_tag,
                                       all_entities: false
          end

          before do
            request.accept = saml_content
            get :all_entities, params: { instance: instance_identifier }
          end

          context 'response' do
            subject { response }
            it { is_expected.to have_http_status(:not_found) }
            it 'has relevant MUST/SHOULD headers per specification' do
              expect(subject.headers['Cache-Control'])
                .to eq('max-age=600, private')
            end
          end
        end

        context 'MetadataInstance does allow rendering all entities' do
          let!(:metadata_instance) do
            create :metadata_instance, primary_tag: primary_tag,
                                       all_entities: true
          end
          let!(:known_entities) do
            create_list :known_entity, 2, :with_idp
          end
          let(:etag) do
            caching.generate_document_entities_etag(metadata_instance,
                                                    known_entities)
          end

          before do
            known_entities.each do |ke|
              create :tag, name: primary_tag, known_entity: ke
            end

            request.accept = saml_content
          end

          context 'initial request' do
            def run
              get :all_entities, params: { instance: instance_identifier }
            end

            context 'uncached server side' do
              context 'response' do
                before { run }
                subject { response }

                include_examples '200 response'
                include_examples 'entities descriptor response'
              end

              context 'cache' do
                it 'updates server side cache' do
                  expect { run }
                    .to(change { Rails.cache.fetch("metadata:#{etag}") })
                end
              end
            end

            context 'cached server side' do
              before { run } # pre-cache data

              context 'response' do
                subject { response }
                before { Timecop.freeze { run } }

                include_examples '200 response'
                include_examples 'entities descriptor response'
              end

              context 'cache' do
                it 'does not modify server side cache' do
                  expect { run }
                    .not_to(change { Rails.cache.fetch("metadata:#{etag}") })
                end
              end
            end
          end

          context 'subsequent requests' do
            def run
              get :all_entities, params: { instance: instance_identifier }
            end

            before do
              run
              @etag = response.headers['ETag']
              @last_modified = Time.rfc822(response.headers['Last-Modified'])
            end

            context 'ETags' do
              context 'with valid resource ETag' do
                before do
                  request.headers['If-None-Match'] = @etag
                  run
                end

                context 'response' do
                  subject { response }
                  it { is_expected.to have_http_status(:not_modified) }
                end
              end

              context 'with invalid resource ETag' do
                before do
                  request.headers['If-None-Match'] = Faker::Lorem.word
                  run
                end

                context 'response' do
                  subject { response }

                  include_examples '200 response'
                  include_examples 'entities descriptor response'
                end
              end
            end

            context 'Modification Time' do
              context 'when resource unmodified' do
                before do
                  request.headers['If-Modified-Since'] = @last_modified
                  run
                end

                context 'response' do
                  subject { response }
                  it { is_expected.to have_http_status(:not_modified) }
                end
              end

              context 'when resource modified' do
                before do
                  request.headers['If-Modified-Since'] =
                    @last_modified - 1.second
                  run
                end

                context 'response' do
                  subject { response }

                  include_examples '200 response'
                  include_examples 'entities descriptor response'
                end
              end
            end
          end
        end
      end

      context 'invalid client request' do
        it_behaves_like 'invalid requests' do
          let(:query) do
            get :all_entities, params: { instance: instance_identifier }
          end
        end
      end
    end

    include_examples 'non get request' do
      let(:query) do
        post :all_entities, params: { instance: instance_identifier }
      end
    end
  end

  describe '#specific_entity' do
    RSpec.shared_examples 'Specific Entity Descriptor' do
      context 'GET' do
        before { request.accept = saml_content }
        context 'valid client request' do
          let(:etag) do
            caching.generate_document_entities_etag(
              metadata_instance, [entity_descriptor.known_entity]
            )
          end
          context 'valid entity_descriptor' do
            context 'initial request' do
              context 'uncached server side' do
                context 'response' do
                  before { run }
                  subject { response }

                  include_examples '200 response'
                  include_examples 'entity descriptor response'
                end

                context 'cache' do
                  it 'updates server side cache' do
                    expect { run }
                      .to(change { Rails.cache.fetch("metadata:#{etag}") })
                  end
                end
              end

              context 'cached server side' do
                before { run } # pre-cache data

                context 'response' do
                  subject { response }
                  before { Timecop.freeze { run } }

                  include_examples '200 response'
                  include_examples 'entity descriptor response'
                end

                context 'cache' do
                  it 'does not modify server side cache' do
                    expect { run }
                      .not_to(change { Rails.cache.fetch("metadata:#{etag}") })
                  end
                end
              end

              context 'unexpected schema verification failure' do
                before do
                  doc = double('schema', valid?: false,
                                         validate: ['nokogiri error'])
                  allow(subject).to receive(:metadata_schema).and_return(doc)
                end
                it 'responds with an internal server error' do
                  expect { run }.to raise_error(Metadata::SchemaInvalidError)
                end
              end
            end

            context 'subsequent requests' do
              before do
                run
                @etag = response.headers['ETag']
                @last_modified = Time.rfc822(response.headers['Last-Modified'])
              end

              context 'ETags' do
                context 'with valid resource ETag' do
                  before do
                    request.headers['If-None-Match'] = @etag
                    run
                  end

                  context 'response' do
                    subject { response }
                    it { is_expected.to have_http_status(:not_modified) }
                  end
                end

                context 'with invalid resource ETag' do
                  before do
                    request.headers['If-None-Match'] = Faker::Lorem.word
                    run
                  end

                  context 'response' do
                    subject { response }

                    include_examples '200 response'
                    include_examples 'entity descriptor response'
                  end
                end
              end

              context 'Modification Time' do
                context 'when resource unmodified' do
                  before do
                    request.headers['If-Modified-Since'] = @last_modified
                    run
                  end

                  context 'response' do
                    subject { response }
                    it { is_expected.to have_http_status(:not_modified) }
                  end
                end

                context 'when resource modified' do
                  before do
                    request.headers['If-Modified-Since'] =
                      @last_modified - 1.second
                    run
                  end

                  context 'response' do
                    subject { response }

                    include_examples '200 response'
                    include_examples 'entity descriptor response'
                  end
                end
              end
            end
          end

          context 'invalid entity_descriptor' do
            before do
              get :specific_entity, params: {
                instance: instance_identifier,
                identifier: 'https://example.edu/shibboleth'
              }
            end

            context 'response' do
              subject { response }
              it { is_expected.to have_http_status(:not_found) }
              it 'has relevant MUST/SHOULD headers per specification' do
                expect(subject.headers['Cache-Control'])
                  .to eq('max-age=600, private')
              end
            end
          end
        end

        context 'invalid client request' do
          it_behaves_like 'invalid requests' do
            let(:query) do
              get :specific_entity, params: {
                instance: instance_identifier,
                identifier: entity_id
              }
            end
          end
        end
      end

      include_examples 'non get request' do
        let(:query) do
          post :specific_entity, params: {
            instance: instance_identifier,
            identifier: entity_id
          }
        end
      end
    end

    context 'With URI identifier' do
      def run
        get :specific_entity, params: {
          instance: instance_identifier,
          identifier: entity_id
        }
      end

      context 'EntityDescriptor' do
        let(:idp_sso_descriptor) { create :idp_sso_descriptor }
        let(:entity_descriptor) { idp_sso_descriptor.entity_descriptor }
        let(:entity_id) { entity_descriptor.entity_id.uri }

        include_examples 'Specific Entity Descriptor'
      end

      context 'RawEntityDescriptor' do
        let(:entity_descriptor) { create :raw_entity_descriptor }
        let(:entity_id) { entity_descriptor.entity_id.uri }

        include_examples 'Specific Entity Descriptor'
      end
    end

    context 'With sha1 identifier' do
      def run
        identifier = "{sha1}#{Digest::SHA1.hexdigest(entity_id)}"
        get :specific_entity_sha1, params: {
          instance: instance_identifier,
          identifier: identifier
        }
      end

      context 'EntityDescriptor' do
        let(:idp_sso_descriptor) { create :idp_sso_descriptor }
        let(:entity_descriptor) { idp_sso_descriptor.entity_descriptor }
        let(:entity_id) { entity_descriptor.entity_id.uri }

        include_examples 'Specific Entity Descriptor'
      end

      context 'RawEntityDescriptor' do
        let(:entity_descriptor) { create :raw_entity_descriptor }
        let(:entity_id) { entity_descriptor.entity_id.uri }

        include_examples 'Specific Entity Descriptor'
      end
    end
  end

  describe '#tagged_entities' do
    let(:primary_tag2) { "#{Faker::Lorem.word}_2" }
    let(:secondary_tag) { "#{Faker::Lorem.word}_#{Faker::Lorem.word}" }

    context 'GET' do
      context 'valid client request' do
        context 'MetadataInstance has no entities matching tag' do
          before do
            request.accept = saml_content
            get :tagged_entities, params: {
              instance: instance_identifier,
              identifier: secondary_tag
            }
          end

          context 'response' do
            subject { response }
            it { is_expected.to have_http_status(:not_found) }
            it 'has relevant MUST/SHOULD headers per specification' do
              expect(subject.headers['Cache-Control'])
                .to eq('max-age=600, private')
            end
          end
        end

        context 'MetadataInstance has entities matching tag' do
          let!(:known_entities) do
            create_list(:known_entity, 2, :with_idp) +
              create_list(:known_entity, 2, :with_raw_entity_descriptor)
          end
          let!(:untagged_known_entities) do
            create_list :known_entity, 2, :with_idp
          end
          let!(:metadata_instance2) do
            create :metadata_instance, primary_tag: primary_tag2
          end
          let!(:known_entities2) do
            create_list :known_entity, 2, :with_idp
          end
          let(:etag) do
            caching.generate_document_entities_etag(metadata_instance,
                                                    known_entities)
          end

          before do
            known_entities.each do |ke|
              create :tag, name: primary_tag, known_entity: ke
              create :tag, name: secondary_tag, known_entity: ke
            end
            untagged_known_entities.each do |ke|
              create :tag, name: primary_tag, known_entity: ke
            end
            known_entities2.each do |ke|
              create :tag, name: primary_tag2, known_entity: ke
              create :tag, name: secondary_tag, known_entity: ke
            end

            request.accept = saml_content
          end

          def run
            get :tagged_entities, params: {
              instance: instance_identifier,
              identifier: secondary_tag
            }
          end

          context 'initial request' do
            context 'uncached server side' do
              context 'response' do
                before { run }
                subject { response }

                include_examples '200 response'
                include_examples 'entities descriptor response'
              end

              context 'cache' do
                it 'updates server side cache' do
                  expect { run }
                    .to(change { Rails.cache.fetch("metadata:#{etag}") })
                end
              end

              context 'supplied entities' do
                before { run }

                it 'has 4 known entities in metadata_instance' do
                  expect(KnownEntity.with_all_tags(primary_tag).count).to eq(6)
                end

                it 'has 4 known entities with secondary tag' do
                  expect(KnownEntity.with_all_tags(secondary_tag).count)
                    .to eq(6)
                end

                it 'renders only the 2 matching entities in metadata xml' do
                  xml = Capybara::Node::Simple.new(
                    Nokogiri::XML.parse(response.body)
                  )

                  path = '/xmlns:EntitiesDescriptor/xmlns:EntityDescriptor'
                  expect(xml.all(:xpath, path).count).to eq(4)
                end
              end
            end

            context 'cached server side' do
              before { run } # pre-cache data

              context 'response' do
                subject { response }
                before { Timecop.freeze { run } }

                include_examples '200 response'
                include_examples 'entities descriptor response'
              end

              context 'cache' do
                it 'does not modify server side cache' do
                  expect { run }
                    .not_to(change { Rails.cache.fetch("metadata:#{etag}") })
                end
              end
            end
          end

          context 'subsequent requests' do
            before do
              run
              @etag = response.headers['ETag']
              @last_modified = Time.rfc822(response.headers['Last-Modified'])
            end

            context 'ETags' do
              context 'with valid resource ETag' do
                before do
                  request.headers['If-None-Match'] = @etag
                  run
                end

                context 'response' do
                  subject { response }
                  it { is_expected.to have_http_status(:not_modified) }
                end
              end

              context 'with invalid resource ETag' do
                before do
                  request.headers['If-None-Match'] = Faker::Lorem.word
                  run
                end

                context 'response' do
                  subject { response }

                  include_examples '200 response'
                  include_examples 'entities descriptor response'
                end
              end
            end

            context 'Modification Time' do
              context 'when resource unmodified' do
                before do
                  request.headers['If-Modified-Since'] = @last_modified
                  run
                end

                context 'response' do
                  subject { response }
                  it { is_expected.to have_http_status(:not_modified) }
                end
              end

              context 'when resource modified' do
                before do
                  request.headers['If-Modified-Since'] =
                    @last_modified - 1.second
                  run
                end

                context 'response' do
                  subject { response }

                  include_examples '200 response'
                  include_examples 'entities descriptor response'
                end
              end
            end
          end
        end
      end

      context 'invalid client request' do
        it_behaves_like 'invalid requests' do
          let(:query) do
            get :tagged_entities, params: {
              instance: instance_identifier,
              identifier: secondary_tag
            }
          end
        end
      end
    end

    include_examples 'non get request' do
      let(:query) do
        post :tagged_entities, params: {
          instance: instance_identifier,
          identifier: secondary_tag
        }
      end
    end
  end
end
