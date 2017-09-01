# frozen_string_literal: true

class Organization < Sequel::Model
  one_to_many :organization_names
  one_to_many :organization_display_names
  one_to_many :organization_urls

  # Additional to SAML model for our purposes
  one_to_many :entity_descriptors
  one_to_many :role_descriptors

  plugin :nested_attributes
  nested_attributes :organization_names

  def validate
    super
    validates_presence %i[created_at updated_at]
    validates_presence :organization_names, allow_missing: new?
    validates_presence :organization_display_names, allow_missing: new?
    validates_presence :organization_urls, allow_missing: new?
  end
end
