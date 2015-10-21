require 'rails_helper'

RSpec.describe API::DiscoveryServiceQueryController, type: :controller do
  describe 'GET #index' do
    let(:primary_tag) { Faker::Lorem.word }

    it 'returns http success' do
      get :index, format: :json
      expect(response).to have_http_status(:success)
    end
  end
end