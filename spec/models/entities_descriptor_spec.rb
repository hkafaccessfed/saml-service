require 'rails_helper'

describe EntitiesDescriptor do
  it_behaves_like 'a basic model'
  it_behaves_like 'a taggable model', :entities_descriptor_tag,
                  :entities_descriptor

  it { is_expected.to have_many_to_one :parent_entities_descriptor }
  it { is_expected.to have_one_to_many :entities_descriptors }
  it { is_expected.to have_one_to_many :entity_descriptors }
  it { is_expected.to have_one_to_many :ca_key_infos }
  it { is_expected.to validate_presence :name }

  context 'optional attributes' do
    it { is_expected.to have_one_to_one :registration_info }
    it { is_expected.to have_one_to_one :entity_attribute }

    it { is_expected.to have_column :extensions, type: :text }
  end

  context 'ca_verify_depth' do
    subject { create :entities_descriptor }

    it 'is expected to be present if ca_key_infos is populated' do
      subject.add_ca_key_info create :ca_key_info
      expect(subject).to validate_presence :ca_verify_depth
    end
    it 'is not expected to be present if ca_key_infos is empty' do
      subject.ca_key_infos.clear
      expect(subject).not_to validate_presence :ca_verify_depth
    end
  end

  context 'publication_info' do
    context 'as parent/singular entities_descriptor' do
      subject { create :entities_descriptor }
      it 'validates publication_info is present' do
        expect(subject).to validate_presence :publication_info
      end
    end
    context 'as child entities_descriptor' do
      subject { create :child_entities_descriptor }
      it 'does not validate publication_info is present' do
        expect(subject).not_to validate_presence :publication_info
      end
    end
    context '#locate_publication_info' do
      subject { create :child_entities_descriptor }
      let(:local_publication_info) do
        build :mdrpi_publication_info
      end

      it 'returns local publication_info if present' do
        subject.publication_info = local_publication_info
        expect(subject.locate_publication_info).to eq(local_publication_info)
      end
      it 'returns parent entities_descriptor publication_info if not present' do
        expect(subject.locate_publication_info).to be
          .and eq(subject.parent_entities_descriptor.publication_info)
      end
    end
  end

  context '#ca_keys?' do
    subject { create :entities_descriptor }

    it 'is true if ca_key_infos is populated' do
      subject.add_ca_key_info(create :ca_key_info)
      expect(subject.ca_keys?).to be
    end
    it 'is false if ca_key_infos is empty' do
      subject.ca_key_infos.clear
      expect(subject.ca_keys?).not_to be
    end
  end

  context '#registration_info?' do
    subject { create :entities_descriptor }

    it 'is true if registration_info is populated' do
      subject.registration_info = create(:mdrpi_registration_info)
      expect(subject.registration_info?).to be
    end
    it 'is false if registration_info is empty' do
      subject.registration_info = nil
      expect(subject.registration_info?).not_to be
    end
  end

  context '#entity_attribute?' do
    subject { create :entities_descriptor }

    it 'is true when an entity_attribute is set' do
      subject.entity_attribute = create :mdattr_entity_attribute
      expect(subject.entity_attribute?).to be
    end
    it 'is false when an entity_attribute is not set' do
      expect(subject.entity_attribute?).not_to be
    end
  end

  context '#sibling?' do
    context 'with parent entities descriptor' do
      subject { create :child_entities_descriptor }
      it 'is true' do
        expect(subject.sibling?).to be
      end
    end
    context 'without parent entities descriptor' do
      subject { create :entities_descriptor }
      it 'is false' do
        expect(subject.sibling?).not_to be
      end
    end
  end
end
