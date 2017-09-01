# frozen_string_literal: true

module MDUI
  class PrivacyStatementURL < LocalizedURI
    many_to_one :ui_info

    def validate
      super
      validates_presence :ui_info
    end
  end
end
