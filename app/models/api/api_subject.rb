# frozen_string_literal: true

module API
  class APISubject < Sequel::Model
    include Accession::Principal

    many_to_many :roles, class: 'Role'

    def permissions
      roles.flat_map { |role| role.permissions.map(&:value) }
    end

    def functioning?
      enabled
    end

    def validate
      validates_presence %i[x509_cn description
                            contact_name contact_mail enabled
                            created_at updated_at]

      validates_unique :x509_cn
      validates_format(/\A[\w-]+\z/, :x509_cn)
    end
  end
end
