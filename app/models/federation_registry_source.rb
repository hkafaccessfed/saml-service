# frozen_string_literal: true

class FederationRegistrySource < Sequel::Model
  many_to_one :entity_source

  def validate
    validates_presence %i[created_at updated_at]
    validates_presence %i[entity_source hostname secret
                          registration_authority registration_policy_uri
                          registration_policy_uri_lang]
    validates_format(/\A[\w-]+\z/, :secret)
    validate_hostname
  end

  def validate_hostname
    URI.parse("https://#{hostname}")
  rescue URI::InvalidURIError
    errors.add(:hostname, 'could not be parsed as part of a valid URI')
  end

  def organizations_url
    export_url('organizations')
  end

  def entity_descriptors_url
    export_url('entitydescriptors')
  end

  def identity_providers_url
    export_url('identityproviders')
  end

  def service_providers_url
    export_url('serviceproviders')
  end

  def attribute_authorities_url
    export_url('attributeauthorities')
  end

  def contacts_url
    export_url('contacts')
  end

  def attributes_url
    export_url('attributes')
  end

  private

  def export_url(part)
    URI.parse("https://#{hostname}/federationregistry/export/#{part}")
  end
end
