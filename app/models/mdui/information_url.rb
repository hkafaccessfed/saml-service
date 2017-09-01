# frozen_string_literal: true

module MDUI
  class InformationURL < LocalizedURI
    many_to_one :ui_info

    def validate
      super
      validates_presence :ui_info
    end
  end
end
