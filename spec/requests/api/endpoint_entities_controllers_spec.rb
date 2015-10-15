require 'rails_helper'

module API
  RSpec.describe EndpointEntitiesController, type: :request do
    let(:json) { JSON.parse(response.body) }

    context 'get /api/endpoint_entity/index.json' do
      def run
        get '/api/endpoint_entity/index.json'
      end

      let!(:entity) { create(:known_entity) }
      before { run }

      it 'lists the entities' do
        expect(json[:entities])
          .to include(entity_id: entity.id)
      end
    end
  end
end
