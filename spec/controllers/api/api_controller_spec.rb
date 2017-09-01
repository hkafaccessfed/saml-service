# frozen_string_literal: true

require 'rails_helper'

require 'gumboot/shared_examples/api_controller'

RSpec.describe API::APIController, type: :controller do
  include_examples 'API base controller'

  context 'requesting resource that does not exist' do
    let(:api_subject) { create(:api_subject) }
    before { request.env['HTTP_X509_DN'] = "CN=#{api_subject.x509_cn}".dup }

    controller(API::APIController) do
      def missing_resource
        public_action
        raise(API::APIController::ResourceNotFound)
      end
    end

    before do
      @routes.draw do
        get '/api/missing_resource' => 'api/api#missing_resource'
      end
    end

    before { get :missing_resource }
    subject { response }
    let(:data) { JSON.parse(response.body) }

    it { is_expected.to have_http_status(:not_found) }

    it 'responds with the exception' do
      expect(data['message']).to match(/Resource not found/)
    end
  end

  context 'a bad request' do
    let(:api_subject) { create(:api_subject) }
    before { request.env['HTTP_X509_DN'] = "CN=#{api_subject.x509_cn}".dup }

    controller(API::APIController) do
      def a_bad_request
        public_action
        raise(API::APIController::BadRequest)
      end
    end

    before do
      @routes.draw do
        get '/api/a_bad_request' => 'api/api#a_bad_request'
      end
    end

    before { get :a_bad_request }
    subject { response }
    let(:data) { JSON.parse(response.body) }

    it { is_expected.to have_http_status(:bad_request) }

    it 'responds with the exception' do
      expect(data['message']).to match(/Bad request/)
    end
  end
end
