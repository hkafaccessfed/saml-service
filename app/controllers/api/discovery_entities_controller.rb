module API
  class DiscoveryEntitiesController < APIController
    skip_before_action :ensure_authenticated

    def index
      public_action
      @identity_providers = identity_providers.select(&:functioning?)
      @service_providers = service_providers.select(&:functioning?)
    end

    private

    COMMON_EAGER_FETCH = {
      entity_id: [],
      known_entity: :tags,
      role_descriptors: [],
      organization: [],
      registration_info: []
    }

    SP_EAGER_FETCH = COMMON_EAGER_FETCH.merge(
      sp_sso_descriptors: {
        ui_info: %i(logos descriptions display_names information_urls
                    privacy_statement_urls),
        discovery_response_services: [],
        tags: []
      }
    )

    IDP_EAGER_FETCH = COMMON_EAGER_FETCH.merge(
      idp_sso_descriptors: {
        ui_info: %i(logos descriptions display_names),
        disco_hints: %i(geolocation_hints domain_hints),
        tags: []
      }
    )

    private_constant :SP_EAGER_FETCH, :IDP_EAGER_FETCH

    def service_providers
      entities_with_role_descriptor(:sp_sso_descriptors)
        .eager(SP_EAGER_FETCH).all
    end

    def identity_providers
      entities_with_role_descriptor(:idp_sso_descriptors)
        .eager(IDP_EAGER_FETCH).all
    end

    def entities_with_role_descriptor(table)
      EntityDescriptor.qualify.distinct(:id)
        .join(table, entity_descriptor_id: :id)
    end
  end
end
