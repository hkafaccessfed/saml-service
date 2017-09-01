# frozen_string_literal: true

class ServiceDescription < LocalizedName
  many_to_one :attribute_consuming_service

  def validate
    super
    validates_presence :attribute_consuming_service
  end
end
