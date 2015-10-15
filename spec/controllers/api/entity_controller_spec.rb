require 'rails_helper'

module API
  RSpec.describe EntityController, type: :controller do
    describe 'GET #index' do
      it 'returns http success' do
        get :index, format: :json
        expect(response).to have_http_status(:success)
      end

      let(:json) { JSON.parse(response.body) }

      context 'get /entities' do
        def run
          get :index, format: :json
        end

        let!(:entity) { create(:known_entity) }
        before { run }

        it 'gets the entities' do
          # not_to include for instance
          expect(json[:entity])
            .not_to include(not_to: 'not_to')
        end
      end
    end
  end
end
