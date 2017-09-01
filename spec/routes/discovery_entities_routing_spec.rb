# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::DiscoveryEntitiesController, type: :routing do
  def route_to_action(name, opts = {})
    route_to(opts.reverse_merge(controller: 'api/discovery_entities',
                                action: name, format: 'json'))
  end

  describe 'get /api/discovery/entities' do
    subject { { get: '/api/discovery/entities' } }
    it { is_expected.to route_to_action('index') }
  end
end
