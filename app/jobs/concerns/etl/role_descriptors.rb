module ETL
  module RoleDescriptors
    def role_descriptor(rd, rd_data, scopes_data)
      scopes(rd, scopes_data) if scopes_data
      contact_people(rd, rd_data[:contact_people])
      protocol_supports(rd, rd_data[:protocol_support_enumerations])
      key_descriptors(rd, rd_data[:key_descriptors])
    end

    def scopes(rd, scope_data)
      rd.scopes.each(&:destroy)
      rd.add_scope(SHIBMD::Scope.new(value: scope_data,
                                     regexp: regexp_scope?(scope_data)))
    end

    def contact_people(rd, contact_people)
      # Contacts are stored at the ED level only within saml-service
      # This is more inline with eduGain policy and prevents duplication
      rd.entity_descriptor.contact_people.each(&:destroy)
      contact_people.each do |contact_person|
        type = contact_person[:type][:name].to_sym
        next unless ContactPerson::TYPE.key?(type)

        c = rd_contact(contact_person)
        next unless c

        cp = ContactPerson.create(contact: c, contact_type: type)
        rd.entity_descriptor.add_contact_person(cp)
      end
    end

    def rd_contact(contact_person)
      FederationRegistryObject.local_instance(contact_person[:contact][:id],
                                              Contact.dataset)
    end

    def regexp_scope?(scope)
      !(scope =~ /\^(.+)\$/).nil?
    end

    def protocol_supports(rd, protocol_support_data)
      rd.protocol_supports.each(&:destroy)
      protocol_support_data.each do |ps|
        rd.add_protocol_support(ProtocolSupport.new(uri: ps[:uri]))
      end
    end

    def key_descriptors(rd, key_descriptor_data)
      rd.key_descriptors.each(&:destroy)

      key_descriptor_data.each do |kd_data|
        begin
          rd.add_key_descriptor(key_descriptor(kd_data))
        rescue OpenSSL::X509::CertificateError => e
          Rails.logger.info(
            "FR certificate \n#{kd_data[:key_info][:certificate][:data]}\n" \
            "was invalid and not persisted due to: #{e.message}")
        end
      end
    end

    def key_descriptor(kd_data)
      key_type = kd_data.key?(:type) ? kd_data[:type].to_sym : nil
      kd = KeyDescriptor.create(key_type: key_type,
                                disabled: kd_data.fetch(:disabled, false))
      key_info(kd, kd_data)
      kd
    end

    def key_info(kd, kd_data)
      return unless kd_data.key?(:key_info)

      ki_data = kd_data[:key_info]
      return unless ki_data.key?(:certificate)

      cert = ki_data[:certificate]
      return unless cert.key?(:data)

      cert_data = cert[:data].gsub(/(\n\n)/, "\n")
      ki = KeyInfo.create(key_name: ki_data.fetch(:name, nil),
                          subject: cert.fetch(:subject, nil),
                          issuer: cert.fetch(:issuer, nil), data: cert_data)

      kd.update(key_info: ki)
    end

    def mdui(rd, display_name, description)
      ui_info = rd.ui_info || MDUI::UIInfo.create(role_descriptor: rd)
      ui_info.display_names.each(&:destroy)
      ui_info.descriptions.each(&:destroy)

      ui_info.add_display_name(MDUI::DisplayName.new(value: display_name,
                                                     lang: 'en'))
      ui_info.add_description(MDUI::Description.new(value: description,
                                                    lang: 'en'))
    end
  end
end