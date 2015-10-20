require 'rails_helper'

module API
  RSpec.describe EndpointEntitiesController, type: :request do
    let(:json) { JSON.parse(response.body, symbolize_names: true) }

    context 'get /api/json_entities' do
      def run
        get '/api/json_entities'
      end

      let!(:idp) do
        create(:idp_sso_descriptor, :with_ui_info)
      end

      let!(:sp) do
        create(:sp_sso_descriptor, :with_ui_info)
      end

      before(:example) { run }

      it 'lists the identity_providers' do
        expect(json[:identity_providers])
          .to include(entity_id: idp.entity_descriptor.known_entity.entity_id,
                      names: include(value: idp.ui_info
                                            .display_names.first.value,
                                     lang: idp.ui_info
                                           .display_names.first.lang),
                      tags: idp.entity_descriptor.known_entity.tags)
      end

      it 'lists the service_providers' do
        expect(json[:service_providers])
          .to include(entity_id: sp.entity_descriptor.known_entity.entity_id,
                      descovery_response: sp.discovery_response_services.first,
                      names: include(value: sp.ui_info
                                            .display_names.first.value,
                                     lang: sp.ui_info
                                           .display_names.first.lang),
                      tags: sp.entity_descriptor.known_entity.tags)
      end
    end
  end
end
