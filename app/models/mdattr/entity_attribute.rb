module MDATTR
  class EntityAttribute < Sequel::Model
    include Parents

    many_to_one :metadata_instance, class: 'MetadataInstance'
    many_to_one :entity_descriptor, class: 'EntityDescriptor'

    one_to_many :attributes, class: 'Attribute'

    plugin :association_dependencies, attributes: :destroy

    def validate
      super
      validates_presence [:created_at, :updated_at]
      return if new?

      validates_presence :attributes
      single_parent [:metadata_instance, :entity_descriptor]
    end
  end
end
