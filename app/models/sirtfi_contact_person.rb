# frozen_string_literal: true

class SIRTFIContactPerson < Sequel::Model
  many_to_one :contact
  many_to_one :entity_descriptor
  many_to_one :role_descriptor

  def validate
    super
    validates_presence %i[contact created_at updated_at]
  end
end
