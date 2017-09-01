# frozen_string_literal: true

module MDUI
  class IPHint < Sequel::Model
    many_to_one :disco_hints

    def validate
      super
      validates_presence %i[disco_hints block created_at updated_at]
    end
  end
end
