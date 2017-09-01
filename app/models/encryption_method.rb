# frozen_string_literal: true

class EncryptionMethod < Sequel::Model
  many_to_one :key_descriptor

  def validate
    super
    validates_presence %i[key_descriptor algorithm created_at updated_at]
  end
end
