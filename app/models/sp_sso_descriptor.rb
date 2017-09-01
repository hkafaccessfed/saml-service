# frozen_string_literal: true

class SPSSODescriptor < SSODescriptor
  one_to_many :assertion_consumer_services
  one_to_many :attribute_consuming_services
  one_to_many :discovery_response_services

  plugin :association_dependencies, assertion_consumer_services: :destroy,
                                    attribute_consuming_services: :destroy,
                                    discovery_response_services: :destroy

  def validate
    super
    validates_presence %i[authn_requests_signed want_assertions_signed]
    validates_presence :assertion_consumer_services, allow_missing: new?
  end

  def attribute_consuming_services?
    attribute_consuming_services.present?
  end

  def extensions?
    super || discovery_response_services.present?
  end
end
