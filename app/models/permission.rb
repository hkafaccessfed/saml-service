# frozen_string_literal: true

class Permission < Sequel::Model
  many_to_one :role

  def validate
    super
    validates_presence %i[role value]
    validates_format Accession::Permission.regexp, :value
    validates_unique %i[value role_id]
  end
end
