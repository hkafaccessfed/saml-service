# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SetSAMLTypeFromXML do
  let(:known_entity) { spy(KnownEntity) }
  let(:red) { spy(RawEntityDescriptor, known_entity: known_entity) }
  let(:ed_node) { double(Nokogiri::XML::Node) }
  let(:klass) { Class.new { include SetSAMLTypeFromXML } }
  let(:absent_role_descriptor) { nil }
  let(:present_role_descriptor) { double(present?: true) }
  let(:idp_sso_descriptor) { absent_role_descriptor }
  let(:attribute_authority_descriptor) { absent_role_descriptor }
  let(:sp_sso_descriptor) { absent_role_descriptor }
  let(:entity_attributes) { {} }

  def attribute_value(value)
    double(Nokogiri::XML::Node, text: value)
  end

  let(:sirtfi) do
    {
      'urn:oasis:names:tc:SAML:attribute:assurance-certification' =>
      [attribute_value('https://refeds.org/sirtfi')]
    }
  end

  let(:supports_research_scholarship) do
    {
      'http://macedir.org/entity-category-support' =>
      [attribute_value('http://refeds.org/category/research-and-scholarship')]
    }
  end

  let(:conforms_to_research_scholarship) do
    {
      'http://macedir.org/entity-category' =>
      [attribute_value('http://refeds.org/category/research-and-scholarship')]
    }
  end

  let(:xpath_results) do
    {
      'IDPSSODescriptor' => idp_sso_descriptor,
      'AttributeAuthorityDescriptor' => attribute_authority_descriptor,
      'SPSSODescriptor' => sp_sso_descriptor
    }
  end

  subject { klass.new }

  before do
    allow(ed_node).to receive(:xpath) do |path|
      if path =~ /EntityAttributes/
        prefix = './/*[local-name() = "EntityAttributes" ' \
          'and namespace-uri() = "urn:oasis:names:tc:SAML:metadata:attribute"]'\
          '/*[local-name() = "Attribute" ' \
          'and namespace-uri() = "urn:oasis:names:tc:SAML:2.0:assertion" ' \
          'and @Name = "'

        suffix = '"]' \
          '/*[local-name() = "AttributeValue" ' \
          'and namespace-uri() = "urn:oasis:names:tc:SAML:2.0:assertion"]'

        getter = ->(v) { entity_attributes.fetch(v, []) }
      else
        prefix = '//*[local-name() = "'

        suffix = '" and namespace-uri() = ' \
          '"urn:oasis:names:tc:SAML:2.0:metadata"]'

        getter = lambda do |v|
          expect(xpath_results).to have_key(v)
          xpath_results[v]
        end
      end

      pattern = "#{Regexp.escape(prefix)}(.+)#{Regexp.escape(suffix)}"
      match = Regexp.new(pattern).match(path)

      expect(match).to be_present
      getter.call(match[1])
    end
  end

  describe '.set_saml_type' do
    before { subject.set_saml_type(red, ed_node) }

    # Sanity check; the XML would be invalid anyway
    context 'with no type' do
      it 'removes the flags' do
        expect(red).to have_received(:update)
          .with(idp: false, sp: false, standalone_aa: false)
      end

      it 'removes the tags' do
        expect(known_entity).to have_received(:untag_as).with('idp')
        expect(known_entity).to have_received(:untag_as).with('aa')
        expect(known_entity).to have_received(:untag_as).with('sp')
        expect(known_entity).to have_received(:untag_as).with('standalone-aa')
        expect(known_entity).to have_received(:untag_as).with('sirtfi')
        expect(known_entity).to have_received(:untag_as)
          .with('research-and-scholarship')
      end
    end

    context 'with an IDPSSODescriptor' do
      let(:idp_sso_descriptor) { present_role_descriptor }

      it 'sets the flags' do
        expect(red).to have_received(:update)
          .with(idp: true, sp: false, standalone_aa: false)
      end

      it 'adds the tag' do
        expect(known_entity).to have_received(:tag_as).with('idp')
      end

      it 'removes the other tags' do
        expect(known_entity).to have_received(:untag_as).with('aa')
        expect(known_entity).to have_received(:untag_as).with('sp')
        expect(known_entity).to have_received(:untag_as).with('standalone-aa')
      end

      context 'when SIRTFI is asserted' do
        let(:entity_attributes) { sirtfi }

        it 'adds the tag' do
          expect(known_entity).to have_received(:tag_as).with('sirtfi')
        end
      end

      context 'when R&S is supported' do
        let(:entity_attributes) { supports_research_scholarship }

        it 'adds the tag' do
          expect(known_entity).to have_received(:tag_as)
            .with('research-and-scholarship')
        end
      end
    end

    context 'with an SPSSODescriptor' do
      let(:sp_sso_descriptor) { present_role_descriptor }

      it 'sets the flags' do
        expect(red).to have_received(:update)
          .with(sp: true, idp: false, standalone_aa: false)
      end

      it 'adds the tag' do
        expect(known_entity).to have_received(:tag_as).with('sp')
      end

      it 'removes the other tags' do
        expect(known_entity).to have_received(:untag_as).with('idp')
        expect(known_entity).to have_received(:untag_as).with('aa')
        expect(known_entity).to have_received(:untag_as).with('standalone-aa')
      end

      context 'when SIRTFI is asserted' do
        let(:entity_attributes) { sirtfi }

        it 'adds the tag' do
          expect(known_entity).to have_received(:tag_as).with('sirtfi')
        end
      end

      context 'when conforming to R&S' do
        let(:entity_attributes) { conforms_to_research_scholarship }

        it 'adds the tag' do
          expect(known_entity).to have_received(:tag_as)
            .with('research-and-scholarship')
        end
      end
    end

    context 'with an AttributeAuthorityDescriptor' do
      let(:attribute_authority_descriptor) { present_role_descriptor }

      it 'sets the flags' do
        expect(red).to have_received(:update)
          .with(sp: false, idp: false, standalone_aa: true)
      end

      it 'adds the tag' do
        expect(known_entity).to have_received(:tag_as).with('standalone-aa')
      end

      it 'removes the other tags' do
        expect(known_entity).to have_received(:untag_as).with('idp')
        expect(known_entity).to have_received(:untag_as).with('aa')
        expect(known_entity).to have_received(:untag_as).with('sp')
      end
    end

    context 'with an IDPSSODescriptor + AttributeAuthorityDescriptor' do
      let(:idp_sso_descriptor) { present_role_descriptor }
      let(:attribute_authority_descriptor) { present_role_descriptor }

      it 'sets the flags' do
        expect(red).to have_received(:update)
          .with(idp: true, sp: false, standalone_aa: false)
      end

      it 'adds the tags' do
        expect(known_entity).to have_received(:tag_as).with('idp')
        expect(known_entity).to have_received(:tag_as).with('aa')
      end

      it 'removes the other tags' do
        expect(known_entity).to have_received(:untag_as).with('sp')
        expect(known_entity).to have_received(:untag_as).with('standalone-aa')
      end
    end
  end
end
