# frozen_string_literal: true

class RequestedAttribute < Attribute
  many_to_one :attribute_consuming_service

  def validate
    validates_presence %i[name created_at updated_at]
    validates_presence %i[reasoning required]
    validates_presence :attribute_consuming_service
  end
end
