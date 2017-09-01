# frozen_string_literal: true

module MDUI
  class DisplayName < LocalizedName
    many_to_one :ui_info

    def validate
      super
      validates_presence :ui_info
    end
  end
end
