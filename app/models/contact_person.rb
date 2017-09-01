# frozen_string_literal: true

class ContactPerson < Sequel::Model
  many_to_one :contact
  many_to_one :entity_descriptor
  many_to_one :role_descriptor

  TYPE = { technical: 0, support: 1, administrative: 2,
           billing: 3, other: 4 }.freeze

  def contact_type
    TYPE.key(contact_type_id)
  end

  def contact_type=(type)
    self.contact_type_id = TYPE[type]
  end

  def validate
    super
    validates_presence %i[contact_type_id contact_type contact
                          created_at updated_at]
    validates_includes %i[technical support administrative
                          billing other], :contact_type
  end
end
