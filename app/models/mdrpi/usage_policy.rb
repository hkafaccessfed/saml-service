# frozen_string_literal: true

module MDRPI
  class UsagePolicy < LocalizedURI
    many_to_one :publication_info

    def validate
      super
      validates_presence :publication_info
    end
  end
end
