module MDRPI
  class RegistrationInfo < Sequel::Model
    include Parents

    many_to_one :metadata_instance, class: 'MetadataInstance'
    many_to_one :entity_descriptor, class: 'EntityDescriptor'

    one_to_many :registration_policies

    plugin :association_dependencies, registration_policies: :destroy

    def validate
      super
      validates_presence [:registration_authority, :created_at, :updated_at]

      return if new?
      validates_presence :registration_policies
      single_parent [:metadata_instance, :entity_descriptor]
    end

    def registration_instant_utc
      return created_at.utc unless registration_instant
      registration_instant.utc
    end
  end
end
