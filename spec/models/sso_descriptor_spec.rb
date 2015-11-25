require 'rails_helper'

describe SSODescriptor do
  it_behaves_like 'a taggable model', :role_descriptor_tag, :role_descriptor
  context 'extends role_descriptor' do
    context 'optional attributes' do
      it { is_expected.to have_one_to_many :artifact_resolution_services }
      it { is_expected.to have_one_to_many :single_logout_services }
      it { is_expected.to have_one_to_many :manage_name_id_services }
      it { is_expected.to have_one_to_many :name_id_formats }
    end
  end

  describe '#artifact_resolution_services?' do
    context 'when populated' do
      subject { create(:sso_descriptor, :with_artifact_resolution_service) }
      it 'is true' do
        expect(subject.artifact_resolution_services?).to be_truthy
      end
    end
    context 'when unpopulated' do
      subject { create :sso_descriptor }
      it 'is false' do
        expect(subject.artifact_resolution_services?).to be_falsey
      end
    end
  end

  describe '#artifact_resolution_services?' do
    context 'when populated' do
      subject { create(:sso_descriptor, :with_artifact_resolution_service) }
      it 'is true' do
        expect(subject.artifact_resolution_services?).to be_truthy
      end
    end
    context 'when unpopulated' do
      subject { create :sso_descriptor }
      it 'is false' do
        expect(subject.artifact_resolution_services?).to be_falsey
      end
    end
  end

  describe '#single_logout_services?' do
    context 'when populated' do
      subject { create(:sso_descriptor, :with_single_logout_service) }
      it 'is true' do
        expect(subject.single_logout_services?).to be_truthy
      end
    end
    context 'when unpopulated' do
      subject { create :sso_descriptor }
      it 'is false' do
        expect(subject.single_logout_services?).to be_falsey
      end
    end
  end

  describe '#manage_name_id_services?' do
    context 'when populated' do
      subject { create(:sso_descriptor, :with_manage_name_id_service) }
      it 'is true' do
        expect(subject.manage_name_id_services?).to be_truthy
      end
    end
    context 'when unpopulated' do
      subject { create :sso_descriptor }
      it 'is false' do
        expect(subject.manage_name_id_services?).to be_falsey
      end
    end
  end

  describe '#name_id_formats?' do
    context 'when populated' do
      subject { create(:sso_descriptor, :with_name_id_format) }
      it 'is true' do
        expect(subject.name_id_formats?).to be_truthy
      end
    end
    context 'when unpopulated' do
      subject { create :sso_descriptor }
      it 'is false' do
        expect(subject.name_id_formats?).to be_falsey
      end
    end
  end

  describe '#destroy' do
    subject do
      create :sso_descriptor, :with_artifact_resolution_services,
             :with_single_logout_services, :with_manage_name_id_services,
             :with_name_id_formats
    end

    it 'is successfully destroyed' do
      expect { subject.destroy }.not_to raise_error
    end
  end
end
