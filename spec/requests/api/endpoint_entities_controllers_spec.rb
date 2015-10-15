require 'rails_helper'

module API
  RSpec.describe EndpointEntitiesController, type: :request do
    let(:json) { JSON.parse(response.body, symbolize_names: true) }
    context 'get /api/endpoint_entities/index.json' do
      def run
        get '/api/endpoint_entities/index.json'
      end

      let!(:entity) { create(:known_entity) }
      before { run }

      it 'lists the entities' do
        expect(json[:entities])
          .to include(Hash)
      end
    end
  end
end
