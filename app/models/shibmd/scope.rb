# frozen_string_literal: true

module SHIBMD
  class Scope < Sequel::Model
    many_to_one :role_descriptor, class: 'RoleDescriptor'

    def validate
      super

      validates_presence %i[role_descriptor value regexp
                            created_at updated_at]
    end
  end
end
