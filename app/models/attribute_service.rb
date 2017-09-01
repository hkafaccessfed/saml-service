# frozen_string_literal: true

class AttributeService < Endpoint
  many_to_one :attribute_authority_descriptor

  def validate
    super
    validates_presence :attribute_authority_descriptor
  end
end
