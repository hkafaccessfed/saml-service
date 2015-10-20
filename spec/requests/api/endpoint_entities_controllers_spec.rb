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
          .entity_descriptor
      end

      let!(:sp) do
        create(:sp_sso_descriptor, :with_ui_info)
          .entity_descriptor
      end

      before(:example) { run }

      it 'lists the identity_providers' do
        expect(json[:identity_providers])
          .to include(entity_id: idp.known_entity.entity_id,
                      tags: idp.known_entity.tags)
      end

      it 'lists the service_providers' do
        expect(json[:service_providers])
          .to include(entity_id: sp.known_entity.entity_id,
                      tags: sp.known_entity.tags)
      end
    end
  end
end
