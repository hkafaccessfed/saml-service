class KeyDescriptor < Sequel::Model
  one_to_one :key_info
  one_to_many :encryption_method

  many_to_one :role_descriptor

  KEY_TYPE = { encryption: 1, signing: 2 }

  def key_type
    KEY_TYPE.key(key_type_id)
  end

  def key_type=(use)
    self.key_type_id = KEY_TYPE[use]
  end

  def validate
    super
    validates_presence [:created_at, :updated_at]
    validates_presence :key_info, allow_missing: new?
    validates_includes [:encryption, :signing], :key_type if key_type?
  end

  def key_type?
    key_type_id && key_type_id > 0
  end
end
