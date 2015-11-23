class AttributeConsumingService < Sequel::Model
  many_to_one :sp_sso_descriptor
  one_to_many :service_names
  one_to_many :service_descriptions
  one_to_many :requested_attributes

  plugin :association_dependencies, service_names: :destroy,
                                    service_descriptions: :destroy,
                                    requested_attributes: :destroy

  def validate
    super
    validates_presence [:created_at, :updated_at]
    validates_presence :index
    validates_presence :default
    validates_presence :sp_sso_descriptor

    validates_presence :service_names, allow_missing: new?
    validates_presence :requested_attributes, allow_missing: new?
  end
end
