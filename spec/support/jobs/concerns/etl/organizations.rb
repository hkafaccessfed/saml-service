# frozen_string_literal: true

RSpec.shared_examples 'ETL::Organizations' do
  # rubocop:disable Metrics/MethodLength
  def create_json(id)
    {
      id: id,
      domain: Faker::Internet.domain_name,
      display_name: Faker::Lorem.sentence,
      description: Faker::Lorem.sentence,
      url: Faker::Internet.url,
      lang: 'en',
      saml: {
        entity_descriptors: [
          {
            id: 2000 + id,
            entity_id: Faker::Internet.url,
            functioning: true
          }
        ]
      },
      created_at: fr_time(org_created_at)
    }
  end
  # rubocop:enable Metrics/MethodLength

  let(:org_created_at) { Time.zone.at(rand(Time.now.utc.to_i)) }
  let(:organization_list) do
    (0...organization_count).reduce([]) { |a, e| a << create_json(1000 + e) }
  end

  before do
    stub_fr_request(:organizations)
    allow_any_instance_of(described_class).to receive(:entity_descriptors)
      .with(kind_of(Organization), anything)
  end

  def run
    described_class.new(id: fr_source.id).organizations
  end

  context 'creating an organization' do
    let(:organizations) { organization_list }
    let(:organization_count) { 1 }
    before { run }
    subject { Organization.last }

    verify(created_at: -> { org_created_at },
           updated_at: -> { truncated_now })

    it 'has an OrganizationName' do
      expect(subject.organization_names.last.value)
        .to eq(organizations.last[:domain])
      expect(subject.organization_names.last.lang)
        .to eq(organizations.last[:lang])
    end

    it 'has an OrganizationDisplayName' do
      expect(subject.organization_display_names.last.value)
        .to eq(organizations.last[:display_name])
      expect(subject.organization_display_names.last.lang)
        .to eq(organizations.last[:lang])
    end

    it 'has an OrganizationURL' do
      expect(subject.organization_urls.last.uri)
        .to eq(organizations.last[:url])
      expect(subject.organization_urls.last.lang)
        .to eq(organizations.last[:lang])
    end
  end

  context 'updating an organization' do
    let(:fr_id) { rand(100..2000) }
    subject { create :organization }

    before do
      record_fr_id(subject, fr_id)
    end

    context 'updated organization' do
      let(:organizations) { [create_json(fr_id)] }

      verify(created_at: -> { subject.created_at },
             updated_at: -> { truncated_now })

      it 'updated created_at' do
        expect { run }
          .to change { subject.reload.created_at }
          .to eq(org_created_at)
      end

      it 'has an OrganizationName' do
        expect { run }
          .to change { subject.reload.organization_names.last.value }
          .to eq(organizations.last[:domain])
      end

      it 'has an OrganizationDisplayName' do
        expect { run }
          .to change { subject.reload.organization_display_names.last.value }
          .to eq(organizations.last[:display_name])
      end

      it 'has an OrganizationURL' do
        expect { run }
          .to change { subject.reload.organization_urls.last.uri }
          .to eq(organizations.last[:url])
      end
    end
  end

  context 'organization json response' do
    let(:organizations) { organization_list }

    shared_examples 'obj creation' do
      it 'creates Organization' do
        expect { run }.to change { Organization.count }.by(organization_count)
      end

      it 'creates OrganizationName' do
        expect { run }
          .to change { OrganizationName.count }.by(organization_count)
      end

      it 'creates OrganizationDisplayName' do
        expect { run }
          .to change { OrganizationDisplayName.count }.by(organization_count)
      end

      it 'creates OrganizationURL' do
        expect { run }
          .to change { OrganizationURL.count }.by(organization_count)
      end
    end

    context 'single new organization' do
      let(:organization_count) { 1 }
      include_examples 'obj creation'
    end

    context 'multiple new organizations' do
      let(:organization_count) { rand(2..20) }
      include_examples 'obj creation'
    end

    context 'updating organizations' do
      let(:organization_count) { 1 }
      before { run }

      context 'subsequent requests' do
        let(:organization_count) { 0 }
        before { run }
        include_examples 'obj creation'
      end
    end
  end
end
