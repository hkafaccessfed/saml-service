# frozen_string_literal: true

RSpec.shared_examples 'md:EntitiesDescriptor xml' do
  let(:schema) { Nokogiri::XML::Schema.new(File.open('schema/top.xsd', 'r')) }
  let(:validation_errors) { schema.validate(Nokogiri::XML.parse(raw_xml)) }

  it 'is schema-valid' do
    expect(validation_errors).to be_empty
  end

  it 'is created' do
    expect(xml).to have_xpath(entities_descriptor_path)
  end

  it 'renders child EntityDescriptors' do
    expect(xml).to have_xpath(entity_descriptor_path, count: 5)
  end

  context 'Extensions' do
    context 'RegistrationInfo set' do
      let(:add_registration_info) { true }
      it 'creates RegistrationInfo node' do
        expect(xml).to have_xpath(registration_info_path, count: 1)
      end
    end
    context 'RegistrationInfo not set' do
      it 'does not create RegistrationInfo node' do
        expect(xml).to have_xpath(registration_info_path, count: 0)
      end
    end

    context 'with EntityAttributes' do
      let(:add_entity_attributes) { true }
      it 'creates EntityAttributes node' do
        expect(xml).to have_xpath(entity_attributes_path, count: 1)
      end
    end
    context 'without EntityAttributes' do
      it 'does not create EntityAttributes node' do
        expect(xml).to have_xpath(entity_attributes_path, count: 0)
      end
    end
  end
end
