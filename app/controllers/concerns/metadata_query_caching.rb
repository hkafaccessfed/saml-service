require 'metadata/schema'
require 'metadata/schema_invalid_error'

module MetadataQueryCaching
  extend ActiveSupport::Concern

  include Metadata::Schema

  def generate_known_entities_etag(known_entities)
    timestamps = known_entities.map(&:updated_at).map(&:to_i).join('.')
    Digest::MD5.hexdigest("samlmetadata/#{timestamps}")
  end

  def generate_descriptor_etag(desc)
    Digest::MD5.hexdigest("samlmetadata/#{desc.id}-#{desc.updated_at}")
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
    cache_expiry_period = @metadata_instance.validity_period
    cache_expiry = Time.now + cache_expiry_period

    Rails.cache.fetch(etag, expires_in: cache_expiry_period) do
      @saml_renderer.root_entity_descriptor(known_entity)
      validate_xml
      @saml_renderer.sign

      { expires: cache_expiry, metadata: @saml_renderer.builder.to_xml }
    end
  end

  def cache_known_entities_response(known_entities, etag)
    cache_expiry_period = @metadata_instance.validity_period
    cache_expiry = Time.now + cache_expiry_period

    Rails.cache.fetch(etag, expires_in: cache_expiry_period) do
      @saml_renderer.entities_descriptor(known_entities)
      validate_xml

      { expires: cache_expiry, metadata: @saml_renderer.sign }
    end
  end

  def validate_xml
    doc = @saml_renderer.builder.doc
    return if metadata_schema.valid?(doc)

    fail Metadata::SchemaInvalidError, 'metadata is not schema valid\n' \
                                       "#{metadata_schema.validate(doc)}"
  end
end
