# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Routes for MetadataQueryController', type: :routing do
  let(:instance) { Faker::Lorem.word }
  let(:identifier) { Faker::Internet.url }
  let(:sha1_identifier) { Digest::SHA1.hexdigest identifier }
  let(:basic_identifier) { Faker::Lorem.word }

  it 'routes /:instance/entities to #all_entities' do
    expect(get("/mdq/#{instance}/entities"))
      .to route_to(
        controller: 'metadata_query',
        action: 'all_entities',
        instance: instance
      )
  end

  it 'routes /:instance/entities/:identifier to #specific_entity' do
    expect(get("/mdq/#{instance}/entities/#{identifier}"))
      .to route_to(
        controller: 'metadata_query',
        action: 'specific_entity',
        instance: instance,
        identifier: identifier
      )
  end

  it 'routes /:instance/entities/:identifier to #specific_entity_sha1' do
    uri = URI.encode("/mdq/#{instance}/entities/{sha1}#{sha1_identifier}")
    expect(get(uri))
      .to route_to(
        controller: 'metadata_query',
        action: 'specific_entity_sha1',
        instance: instance,
        identifier: "{sha1}#{sha1_identifier}"
      )
  end

  it 'routes /:instance/entities/:basic_identifier to #tagged_entities' do
    expect(get("/mdq/#{instance}/entities/#{basic_identifier}"))
      .to route_to(
        controller: 'metadata_query',
        action: 'tagged_entities',
        instance: instance,
        identifier: basic_identifier
      )
  end
end
