# frozen_string_literal: true

class ProtocolSupport < SamlURI
  many_to_one :role_descriptor

  def validate
    super
    validates_presence :role_descriptor
  end
end
