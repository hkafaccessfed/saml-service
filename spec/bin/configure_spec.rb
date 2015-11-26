require 'rails_helper'
require_relative '../../bin/configure'

RSpec.describe ConfigureCLI do
  describe '#fr_source' do
    let(:hostname) { Faker::Internet.domain_name }
    let(:secret) { SecureRandom.urlsafe_base64 }
    let(:registration_authority) { Faker::Internet.domain_name }
    let(:registration_policy) { Faker::Internet.domain_name }
    let(:lang) { Faker::Lorem.word }

    def run(**overrides)
      args = overrides.reverse_merge(
        hostname: hostname,
        secret: secret,
        registration_authority: registration_authority,
        registration_policy: registration_policy,
        lang: lang
      ).transform_keys { |sym| "--#{sym.to_s.dasherize}" }.to_a.flatten

      ConfigureCLI.start(['fr_source', *args])
    end

    context 'when multiple sources exist' do
      let!(:fr_sources) { create_list(:federation_registry_source, 2) }

      it 'raises an error' do
        expect { run }
          .to raise_error('Multiple FederationRegistrySource objects exist')
      end
    end

    context 'when a source exists' do
      let!(:fr_source) { create(:federation_registry_source) }

      it 'updates the secret' do
        new_secret = SecureRandom.urlsafe_base64
        expect { run(secret: new_secret) }
          .to change { fr_source.reload.secret }.to(new_secret)
      end

      it 'updates the hostname' do
        new_hostname = "manager.#{Faker::Internet.domain_name}"
        expect { run(hostname: new_hostname) }
          .to change { fr_source.reload.hostname }.to(new_hostname)
      end

      it 'updates the registration authority' do
        new_registration_authority = Faker::Internet.url
        expect { run(registration_authority: new_registration_authority) }
          .to change { fr_source.reload.registration_authority }
          .to(new_registration_authority)
      end

      it 'updates the registration policy' do
        new_registration_policy = Faker::Internet.url
        expect { run(registration_policy: new_registration_policy) }
          .to change { fr_source.reload.registration_policy_uri }
          .to(new_registration_policy)
      end
    end

    context 'when no source exists' do
      it 'creates a new source' do
        expect { run }
          .to change(FederationRegistrySource, :count).by(1)
      end

      it 'creates an active EntitySource' do
        expect { run }
          .to change(EntitySource, :count).by(1)

        expect(EntitySource.last).to have_attributes(active: true, rank: 10)
      end

      it 'sets the correct registration attributes on the new source' do
        run
        expected = {
          registration_authority: registration_authority,
          registration_policy_uri: registration_policy,
          registration_policy_uri_lang: lang
        }
        expect(FederationRegistrySource.last).to have_attributes(expected)
      end
    end
  end

  describe '#keypair' do
    let(:cert_file) { '/nonexistent/path/to/cert.pem' }
    let(:key_file) { '/nonexistent/path/to/key.pem' }

    let(:rsa_key) { create(:rsa_key) }
    let(:x509_certificate) { create(:certificate, rsa_key: rsa_key) }

    before do
      allow(File).to receive(:read).with(cert_file)
        .and_return(x509_certificate.to_pem)
      allow(File).to receive(:read).with(key_file).and_return(rsa_key.to_pem)
    end

    def run
      ConfigureCLI.start(['keypair',
                          '--cert', cert_file,
                          '--key', key_file])
    end

    context 'when the keypair exists' do
      let!(:keypair) do
        create(:keypair, x509_certificate: x509_certificate, rsa_key: rsa_key)
      end

      it 'creates no new keypair' do
        expect { run }.not_to change(Keypair, :count)
      end

      it 'does not change the existing keypair' do
        expect { run }.not_to change { keypair.reload.to_hash }
      end
    end

    context 'when no keypair exists' do
      it 'creates a keypair' do
        expect { run }.to change(Keypair, :count).by(1)

        expected = { certificate: x509_certificate.to_pem, key: rsa_key.to_pem }
        expect(Keypair.last).to have_attributes(expected)
      end
    end
  end

  describe '#md_instance' do
    let(:hash) { nil }
    let(:name) { "#{Faker::Lorem.word}.#{Faker::Internet.domain_name}" }
    let(:tag) { Faker::Lorem.word }
    let(:publisher) { Faker::Internet.url }
    let(:usage_policy) { Faker::Internet.url }
    let(:lang) { 'en' }
    let!(:keypair) { create(:keypair) }

    let(:cert_file) { '/nonexistent/path/to/cert.pem' }

    before do
      allow(File).to receive(:read).with(cert_file)
        .and_return(keypair.certificate)
    end

    def run
      args = ['md_instance',
              '--cert', cert_file,
              '--name', name,
              '--tag', tag,
              '--publisher', publisher,
              '--usage-policy', usage_policy,
              '--lang', lang]

      args += ['--hash', hash] if hash

      ConfigureCLI.start(args)
    end

    context 'when the metadata instance exists' do
      let!(:instance) { create(:metadata_instance, primary_tag: tag) }

      it 'does not create a new metadata instance' do
        expect { run }.not_to change(MetadataInstance, :count)
      end

      it 'updates the attributes' do
        attrs = { keypair_id: keypair.id, name: name, hash_algorithm: 'sha256' }
        expect { run }.to change { instance.reload.to_hash }.to include(attrs)
      end

      it 'does not create a new PublicationInfo' do
        expect { run }.to not_change(MDRPI::PublicationInfo, :count)
          .and not_change(MDRPI::UsagePolicy, :count)
      end

      it 'updates the PublicationInfo' do
        pi = instance.publication_info
        up = pi.usage_policies.first

        run

        expect { pi.reload }.to change { pi.values }
          .to include(publisher: publisher)

        expect { up.reload }.to change { up.values }
          .to include(uri: usage_policy)
      end

      context 'when the PublicationInfo has two usage_policies' do
        let!(:other_usage_policy) do
          create(:mdrpi_usage_policy,
                 publication_info: instance.publication_info)
        end

        it 'raises an exception' do
          expect { run }.to raise_error(/multiple usage policies/)
        end
      end
    end

    context 'when no metadata instance exists' do
      it 'creates a valid metadata instance' do
        expect { run }.to change(MetadataInstance, :count).by(1)

        expect(MetadataInstance.last).to be_valid
          .and have_attributes(keypair_id: keypair.id, name: name)
      end

      it 'creates a valid PublicationInfo' do
        expect { run }.to change(MDRPI::PublicationInfo, :count).by(1)
          .and change(MDRPI::UsagePolicy, :count).by(1)

        md_instance = MetadataInstance.last

        expect(md_instance.publication_info)
          .to have_attributes(publisher: publisher)

        expect(md_instance.publication_info.usage_policies.first)
          .to have_attributes(uri: usage_policy)
      end
    end

    context 'when the keypair is missing' do
      before { keypair.destroy }

      it 'raises an informative error' do
        expect { run }.to raise_error(/certificate has not been registered/)
      end
    end

    context 'when the hash is provided' do
      let(:hash) { 'sha1' }

      it 'uses the provided hash' do
        run
        expect(MetadataInstance.last).to have_attributes(hash_algorithm: hash)
      end
    end
  end
end
