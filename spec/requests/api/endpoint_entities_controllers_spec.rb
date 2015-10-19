require 'rails_helper'

module API
  RSpec.describe EndpointEntitiesController, type: :request do
    let(:json) { JSON.parse(response.body, symbolize_names: true) }

    context 'get /api/json_entities' do
      def run
        get '/api/json_entities'
      end

      let!(:entity) { create(:known_entity) }

      # it 'lists the entities' do
      #   expect(json[:entities])
      #     .to include(entity_id: entity.entity_id, tags: entity.tags)
      # end
    end
  end
end
