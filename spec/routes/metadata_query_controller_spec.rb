require 'rails_helper'

RSpec.describe 'Routes for MetadataQueryController', type: :routing do
  let(:primary_tag) { Faker::Lorem.word }
  let(:identifier) { Faker::Internet.url }
  let(:sha1_identifier) { Digest::SHA1.hexdigest identifier }
  let(:basic_identifier) { Faker::Lorem.word }

  it 'routes /:primary_tag/entities to #all_entities' do
    expect(get("/mdq/#{primary_tag}/entities"))
      .to route_to(
        controller: 'metadata_query',
        action: 'all_entities',
        primary_tag: primary_tag
      )
  end

  it 'routes /:primary_tag/entities/:identifier to #specific_entity' do
    expect(get("/mdq/#{primary_tag}/entities/#{identifier}"))
      .to route_to(
        controller: 'metadata_query',
        action: 'specific_entity',
        primary_tag: primary_tag,
        identifier: identifier
      )
  end

  it 'routes /:primary_tag/entities/:identifier to #specific_entity_sha1' do
    uri = URI.encode("/mdq/#{primary_tag}/entities/{sha1}#{sha1_identifier}")
    expect(get(uri))
      .to route_to(
        controller: 'metadata_query',
        action: 'specific_entity_sha1',
        primary_tag: primary_tag,
        identifier: "{sha1}#{sha1_identifier}"
      )
  end

  it 'routes /:primary_tag/entities/:basic_identifier to #tagged_entities' do
    expect(get("/mdq/#{primary_tag}/entities/#{basic_identifier}"))
      .to route_to(
        controller: 'metadata_query',
        action: 'tagged_entities',
        primary_tag: primary_tag,
        identifier: basic_identifier
      )
  end
end
