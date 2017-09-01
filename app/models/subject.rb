# frozen_string_literal: true

class Subject < Sequel::Model
  include Accession::Principal

  many_to_many :roles, class: 'Role'

  def permissions
    roles.flat_map { |role| role.permissions.map(&:value) }
  end

  def functioning?
    enabled
  end

  def validate
    validates_presence %i[name mail enabled complete
                          created_at updated_at]
    validates_presence %i[targeted_id shared_token] if complete
  end
end
