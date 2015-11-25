module MDRPI
  class PublicationInfo < Sequel::Model
    include Parents

    many_to_one :metadata_instance, class: 'MetadataInstance'
    many_to_one :entity_descriptor, class: 'EntityDescriptor'

    one_to_many :usage_policies

    plugin :association_dependencies, usage_policies: :destroy

    def validate
      super
      validates_presence [:publisher, :created_at, :updated_at]
      return if new?

      validates_presence :usage_policies
      single_parent [:metadata_instance, :entity_descriptor]
    end
  end
end
