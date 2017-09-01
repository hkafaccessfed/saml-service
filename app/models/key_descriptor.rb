# frozen_string_literal: true

class KeyDescriptor < Sequel::Model
  one_to_one :key_info
  one_to_many :encryption_method

  many_to_one :role_descriptor

  plugin :association_dependencies, key_info: :destroy,
                                    encryption_method: :destroy

  KEY_TYPE = { encryption: 1, signing: 2 }.freeze

  def key_type
    KEY_TYPE.key(key_type_id)
  end

  def key_type=(use)
    self.key_type_id = KEY_TYPE[use]
  end

  def validate
    super
    validates_presence %i[created_at updated_at]
    validates_presence :key_info, allow_missing: new?
    validates_includes %i[encryption signing], :key_type if key_type?
  end

  def key_type?
    key_type_id.try!(:positive?)
  end
end
