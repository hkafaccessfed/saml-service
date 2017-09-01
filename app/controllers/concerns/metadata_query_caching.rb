# frozen_string_literal: true

require 'metadata/schema'
require 'metadata/schema_invalid_error'

module MetadataQueryCaching
  extend ActiveSupport::Concern

  include Metadata::Schema

  def generate_document_entities_etag(metadata_instance, known_entities)
    keys = known_entities.sort_by(&:id)
                         .map { |ke| "#{ke.id}-#{ke.updated_at.to_i}" }

    payload = "samlmetadata/#{metadata_instance.identifier}/#{keys.join('.')}"

    digest = Digest::MD5.hexdigest(payload)
    generate_etag(digest)
  end

  def generate_etag(digest)
    # Ensure that metadata documents that expire in cache will
    # have unique etag values even when Entities have not
    # been updated in the interim.
    last_cached_timestamp =
      Rails.cache.fetch("ts:#{digest}", expires_in: ttl) { Time.now.to_i }

    Digest::MD5.hexdigest("#{last_cached_timestamp}:#{digest}")
  end

  def known_entities_unmodified?(known_entities, etag)
    valid_etag?(etag) || unmodified?(known_entities.sort_by(&:updated_at).last)
  end

  def known_entity_unmodified?(known_entity, etag)
    valid_etag?(etag) || unmodified?(known_entity)
  end

  def valid_etag?(etag)
    return false unless request.headers['If-None-Match']
    request.headers['If-None-Match'] == etag
  end

  def unmodified?(obj)
    return false unless request.headers['If-Modified-Since']
    obj.updated_at <= request.headers['If-Modified-Since']
  end

  def cache_descriptor_response(known_entity, etag)
    Rails.cache.fetch(metadata_cache_name(etag), expires_in: ttl) do
      @saml_renderer.root_entity_descriptor(known_entity)
      validate_xml
      { metadata: @saml_renderer.sign }
    end
  end

  def cache_known_entities_response(known_entities, etag)
    Rails.cache.fetch(metadata_cache_name(etag), expires_in: ttl) do
      @saml_renderer.entities_descriptor(known_entities)
      validate_xml
      { metadata: @saml_renderer.sign }
    end
  end

  def validate_xml
    doc = @saml_renderer.builder.doc
    return if metadata_schema.valid?(doc)

    raise Metadata::SchemaInvalidError,
          "Metadata is not schema valid #{metadata_schema.validate(doc)}"
  end

  def ttl
    @metadata_instance.try(:cache_period) || 6.hours
  end

  def metadata_cache_name(etag)
    "metadata:#{etag}"
  end
end
