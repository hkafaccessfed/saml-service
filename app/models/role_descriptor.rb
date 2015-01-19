class RoleDescriptor < Sequel::Model
  plugin :class_table_inheritance

  many_to_one :entity_descriptor
  many_to_one :organization

  one_to_many :protocol_supports
  one_to_many :key_descriptors
  one_to_many :contact_people

  one_to_one :ui_info, class: 'MDUI::UIInfo'

  def validate
    super
    validates_presence [:entity_descriptor, :active, :created_at, :updated_at]
    return if new?

    validates_presence :protocol_supports
  end
end
