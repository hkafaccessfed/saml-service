require 'rails_helper'

module API
  RSpec.describe EndpointEntitiesController, type: :request do
    let(:json) { JSON.parse(response.body, symbolize_names: true) }

    context 'get /api/json_entities' do
      def run
        get '/api/json_entities'
      end

      let!(:entity) { create(:known_entity) }

      before { run }

      it 'lists the identity_providers' do
        expect(json[:identity_providers])
          .to include(entity_id: entity.entity_id, tags: entity.tags)
      end

      it 'lists the service_providers' do
        expect(json[:service_providers])
          .to include(entity_id: entity.entity_id, tags: entity.tags)
      end
    end
  end
end
