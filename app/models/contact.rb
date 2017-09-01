# frozen_string_literal: true

class Contact < Sequel::Model
  def validate
    super
    validates_presence %i[created_at updated_at]
  end
end
