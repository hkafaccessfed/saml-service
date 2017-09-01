# frozen_string_literal: true

RSpec.shared_examples 'ETL::Common' do
  def endpoint_json(s)
    {
      location: s.location,
      binding: {
        uri: s.binding
      },
      functioning: true
    }
  end

  def indexed_endpoint_json(s)
    {
      location: s.location,
      index: s.index,
      is_default: s.is_default,
      binding: {
        uri: s.binding
      },
      functioning: true
    }
  end

  def saml_uri_json(su)
    {
      uri: su.uri
    }
  end

  def contact_json(c)
    {
      id: c.id,
      given_name: c.given_name,
      surname: c.surname,
      email: c.email_address,
      work_phone: c.telephone_number,
      created_at: Time.zone.at(rand(Time.now.utc.to_i))
    }
  end

  def contact_person_json(contact)
    {
      type: {
        name: ContactPerson::TYPE.keys[rand 0..4].to_s
      },
      contact: {
        id: contact.id
      }
    }
  end

  def sirtfi_contact_person_json(contact)
    {
      type: {
        name: 'Security'
      },
      contact: {
        id: contact.id
      }
    }
  end

  # rubocop:disable Metrics/MethodLength
  def key_descriptor_json(kd)
    {
      disabled: kd.disabled,
      type: kd.key_type,
      key_info: {
        certificate: {
          name: kd.key_info.key_name,
          subject: kd.key_info.subject,
          issuer: kd.key_info.issuer,
          data: kd.key_info.data
        }
      }
    }
  end

  def bad_key_descriptor_json
    {
      disabled: false,
      type: :signing,
      key_info: {
        certificate: {
          name: Faker::Lorem.word,
          subject: Faker::Lorem.word,
          issuer: Faker::Lorem.word,
          data: Faker::Lorem.word
        }
      }
    }
  end
  # rubocop:enable Metrics/MethodLength

  def description
    @description ||= "#{Faker::Lorem.sentence}\r\n\t#{Faker::Lorem.sentence}"
  end

  let(:scope) { 'example.edu' }

  let(:contact_instances) do
    create_list(:contact, contact_count)
  end

  let(:sirtfi_contact_instances) do
    create_list(:contact, sirtfi_contact_count)
  end

  let(:contacts_list) do
    [*contact_instances, *sirtfi_contact_instances]
      .map { |ci| contact_json(ci) }
  end

  let(:contacts) { contacts_list }

  shared_examples 'saml_attributes' do
    it 'has source data' do
      expect(source.count).to be > 0
    end

    it 'creates new instances' do
      expect(target.count)
        .to eq(source.count)
    end

    it 'sets name' do
      source.each_with_index do |s, i|
        expect(target[i].name) == "urn:oid:#{s[:oid]}"
      end
    end

    it 'sets friendly_name' do
      source.each_with_index do |s, i|
        expect(target[i].friendly_name == s[:name])
      end
    end

    it 'sets description' do
      source.each_with_index do |s, i|
        expect(target[i].description == s[:description])
      end
    end

    it 'sets oid' do
      source.each_with_index do |s, i|
        expect(target[i].oid == s[:oid])
      end
    end
  end

  shared_examples 'updating a RoleDescriptor' do
    it 're-uses contact instances' do
      expect { run }.not_to(change { Contact.count })
    end

    it 'updates contact people' do
      expect { run }
        .to(change { subject.entity_descriptor.reload.contact_people })
    end

    it 'updates sirtfi contact people' do
      expect { run }
        .to(change { subject.entity_descriptor.reload.sirtfi_contact_people })
    end

    it 'updates protocol supports' do
      expect { run }.to(change { subject.reload.protocol_supports })
    end

    it 'updates key descriptors' do
      expect { run }.to(change { subject.reload.key_descriptors })
    end
  end

  shared_examples 'updating MDUI content' do
    it 'updates mdui display_names' do
      expect { run }.to(change { subject.reload.ui_info.display_names })
    end

    it 'updates mdui descriptions' do
      expect { run }.to(change { subject.reload.ui_info.descriptions })
    end

    it 'squishes incoming description' do
      run
      expect(subject.reload.ui_info.descriptions.first.value)
        .to eq(description.squish)
    end
  end

  shared_examples 'updating an SSODescriptor' do
    include_examples 'updating a RoleDescriptor'

    it 'updates name id formats' do
      expect { run }.to(change { subject.reload.name_id_formats })
    end

    it 'updates artifact resolution services' do
      expect { run }.to(change { subject.reload.artifact_resolution_services })
    end

    it 'updates single_logout_services' do
      expect { run }.to(change { subject.reload.single_logout_services })
    end

    it 'updates manage name id services' do
      expect { run }.to(change { subject.reload.manage_name_id_services })
    end
  end
end
