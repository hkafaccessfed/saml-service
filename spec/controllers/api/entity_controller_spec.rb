require 'rails_helper'

module API
  RSpec.describe EntityController, type: :controller do
    describe 'GET #index' do
      it 'returns http success' do
        get :index, format: :json
        expect(response).to have_http_status(:success)
      end

      let(:json) { JSON.parse(response.body) }

      context 'get /api/entities' do
        def run
          get :index, format: :json
        end

        let!(:entity) { create(:known_entity) }
        before { run }

        it 'lists the entities' do
          expect(json[:entities])
            .not_to include(name: 'entity.name')
        end
      end
    end
  end
end
