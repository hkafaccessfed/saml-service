class RoleDescriptor < Sequel::Model
  many_to_one :entity_descriptor
  many_to_one :organization

  one_to_many :protocol_supports
  one_to_many :key_descriptors
  one_to_many :contact_people
  one_to_many :scopes, class: 'SHIBMD::Scope'

  one_to_one :ui_info, class: 'MDUI::UIInfo'

  plugin :class_table_inheritance, key: :kind
  plugin :association_dependencies, protocol_supports: :destroy,
                                    key_descriptors: :destroy,
                                    contact_people: :destroy,
                                    scopes: :destroy,
                                    ui_info: :destroy

  def validate
    super
    validates_presence [:entity_descriptor, :enabled, :created_at, :updated_at]
    return if new?

    validates_presence :protocol_supports
  end

  def functioning?
    valid? && enabled
  end

  def extensions?
    extensions.present? || ui_info.present? || scopes.present?
  end

  def key_descriptors?
    key_descriptors.present?
  end

  def contact_people?
    contact_people.present?
  end

  def scopes?
    scopes.present?
  end

  def self.with_any_tag(tags)
    join_tags(tags).all
  end

  def self.with_all_tags(tags)
    join_tags(tags).having { "count(*) = #{[tags].flatten.length}" }.all
  end

  def self.join_tags(tags)
    join(:tags, role_descriptor_id: :id, name: tags).group(:role_descriptor_id)
  end

  def edugain_compliant?
    ui_info.present? &&
      ui_info.display_names.present? &&
      ui_info.descriptions.present?
  end
end
