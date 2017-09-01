# frozen_string_literal: true

class NameIdFormat < SamlURI
  include Parents

  many_to_one :sso_descriptor
  many_to_one :attribute_authority_descriptor

  def validate
    super
    return if new?

    single_parent %i[sso_descriptor attribute_authority_descriptor]
  end
end
