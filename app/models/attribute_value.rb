# frozen_string_literal: true

class AttributeValue < Sequel::Model
  many_to_one :attribute

  def validate
    super
    validates_presence %i[value created_at updated_at]
    validates_presence :attribute
  end
end
