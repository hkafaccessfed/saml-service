# frozen_string_literal: true

module MDUI
  class DomainHint < Sequel::Model
    many_to_one :disco_hints

    def validate
      super
      validates_presence %i[disco_hints domain created_at updated_at]
    end
  end
end
