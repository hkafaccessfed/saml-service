module ETL
  module EntityDescriptors
    def entity_descriptors(o, org_data)
      org_data[:saml][:entity_descriptors].each do |ed_ref|
        ed_data = fr_entity_descriptors[ed_ref[:id]]
        create_or_update_ed(o, EntityDescriptor.dataset, ed_data)
      end
    end

    def create_or_update_ed(o, ds, ed_data)
      Rails.logger.info "Processing FR entity #{ed_data[:entity_id]}"

      ed =
        create_or_update_by_fr_id(ds, ed_data[:id], ed_attrs(ed_data)) do |obj|
          obj.organization = o
          obj.known_entity = known_entity(ed_data)
        end

      ed_saml_core(ed, ed_data)
      tag_known_entity(ed)
      indicate_content_updated(ed.known_entity)
    end

    def known_entity(ed_data)
      KnownEntity.create(entity_source: source, active: ed_data[:active])
    end

    def ed_saml_core(ed, ed_data)
      entity_id(ed, ed_data)
      registration_info(ed)
      identity_providers(ed, ed_data)
      attribute_authorities(ed, ed_data)
    end

    def tag_known_entity(ed)
      # Only specify tags when not locally managed (i.e. first import)
      return if ed.known_entity.tags.present?
      ed.known_entity.add_tag(Tag.new(name: @primary_tag))
    end

    def ed_attrs(ed_data)
      { created_at: Time.parse(ed_data[:created_at]),
        enabled: ed_data[:functioning] }
    end

    def entity_id(ed, ed_data)
      return ed.entity_id.update(uri: ed_data[:entity_id]) if ed.entity_id
      EntityId.create(uri: ed_data[:entity_id], entity_descriptor: ed)
    end

    def registration_info(ed)
      return if ed.registration_info
      ri = MDRPI::RegistrationInfo.create(registration_authority:
                                          @fr_source.registration_authority,
                                          entity_descriptor: ed)
      MDRPI::RegistrationPolicy.create(
        registration_info: ri,
        uri: @fr_source.registration_policy_uri,
        lang: @fr_source.registration_policy_uri_lang)
    end

    def indicate_content_updated(ke)
      # Changes updated_at timestamp for associated KnownEntity
      # which is used by MDQP for etag generation / caching.
      ke.touch
    end
  end
end
