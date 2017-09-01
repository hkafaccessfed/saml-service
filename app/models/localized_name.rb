# frozen_string_literal: true

class LocalizedName < Sequel::Model
  plugin :class_table_inheritance

  def validate
    super
    validates_presence %i[value lang created_at updated_at]
  end
end
