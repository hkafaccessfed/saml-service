# frozen_string_literal: true

require 'rails_helper'

describe IDPSSODescriptor do
  context 'extends sso_descriptor' do
    it { is_expected.to have_many_to_one :entity_descriptor }
    it { is_expected.to have_one_to_many :single_sign_on_services }

    context 'optional attributes' do
      it { is_expected.to have_one_to_many :name_id_mapping_services }
      it { is_expected.to have_one_to_many :assertion_id_request_services }
      it { is_expected.to have_one_to_many :attribute_profiles }
      it { is_expected.to have_one_to_many :attributes }
    end

    context 'validations' do
      it { is_expected.to validate_presence :entity_descriptor }
      it { is_expected.to validate_presence :want_authn_requests_signed }

      context 'instance validations' do
        let(:subject) { create :idp_sso_descriptor }
        it 'has at least 1 single sign on service' do
          expect(subject).to validate_presence :single_sign_on_services
        end
      end
    end

    describe '#extensions?' do
      context 'without extensions, ui_info or disco_hints' do
        it 'is false' do
          expect(subject.extensions?).to be_falsey
        end
      end
      context 'with extensions' do
        subject { create :idp_sso_descriptor, :with_extensions }
        it 'is true' do
          expect(subject.extensions?).to be_truthy
        end
      end
      context 'with ui_info' do
        subject { create :idp_sso_descriptor, :with_ui_info }
        it 'is true' do
          expect(subject.extensions?).to be_truthy
        end
      end
      context 'with disco_hints' do
        subject { create :idp_sso_descriptor, :with_disco_hints }
        it 'is true' do
          expect(subject.extensions?).to be_truthy
        end
      end
      context 'with extensions, ui_info and disco_hints' do
        subject do
          create :idp_sso_descriptor,
                 :with_ui_info, :with_disco_hints, :with_extensions
        end
        it 'is true' do
          expect(subject.extensions?).to be_truthy
        end
      end
    end

    describe '#name_id_mapping_services?' do
      context 'when populated' do
        subject { create(:idp_sso_descriptor, :with_name_id_mapping_services) }
        it 'is true' do
          expect(subject.name_id_mapping_services?).to be_truthy
        end
      end
      context 'when unpopulated' do
        subject { create :idp_sso_descriptor }
        it 'is false' do
          expect(subject.name_id_mapping_services?).to be_falsey
        end
      end
    end

    describe '#assertion_id_request_services?' do
      context 'when populated' do
        subject do
          create(:idp_sso_descriptor, :with_assertion_id_request_services)
        end
        it 'is true' do
          expect(subject.assertion_id_request_services?).to be_truthy
        end
      end
      context 'when unpopulated' do
        subject { create :idp_sso_descriptor }
        it 'is false' do
          expect(subject.assertion_id_request_services?).to be_falsey
        end
      end
    end

    describe '#attribute_profiles?' do
      context 'when populated' do
        subject do
          create(:idp_sso_descriptor, :with_attribute_profiles)
        end
        it 'is true' do
          expect(subject.attribute_profiles?).to be_truthy
        end
      end
      context 'when unpopulated' do
        subject { create :idp_sso_descriptor }
        it 'is false' do
          expect(subject.attribute_profiles?).to be_falsey
        end
      end
    end

    describe '#attributes?' do
      context 'when populated' do
        subject do
          create(:idp_sso_descriptor, :with_attributes)
        end
        it 'is true' do
          expect(subject.attributes?).to be_truthy
        end
      end
      context 'when unpopulated' do
        subject { create :idp_sso_descriptor }
        it 'is false' do
          expect(subject.attributes?).to be_falsey
        end
      end
    end

    describe '#disco_hints?' do
      context 'when populated' do
        subject do
          create(:idp_sso_descriptor, :with_disco_hints)
        end
        it 'is true' do
          expect(subject.disco_hints?).to be_truthy
        end
      end
      context 'when unpopulated' do
        subject { create :idp_sso_descriptor }
        it 'is false' do
          expect(subject.disco_hints?).to be_falsey
        end
      end
    end
  end

  describe '#destroy' do
    subject do
      create :idp_sso_descriptor, :with_requests_signed,
             :with_key_descriptors, :with_ui_info,
             :with_single_logout_services, :with_manage_name_id_services,
             :with_artifact_resolution_services, :with_name_id_formats,
             :with_multiple_single_sign_on_services,
             :with_assertion_id_request_services,
             :with_name_id_mapping_services, :with_attribute_profiles,
             :with_attributes, :with_disco_hints
    end

    it 'is successfully destroyed' do
      expect { subject.destroy }.not_to raise_error
    end
  end
end
