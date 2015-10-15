require 'rails_helper'

module API
  RSpec.describe EntityController, type: :request do
    let(:json) { JSON.parse(response.body) }

    context 'get /api/entities' do
      def run
        get '/api/entities', nil, headers
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
