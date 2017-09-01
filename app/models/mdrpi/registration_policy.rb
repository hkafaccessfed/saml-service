# frozen_string_literal: true

module MDRPI
  class RegistrationPolicy < LocalizedURI
    many_to_one :registration_info

    def validate
      super

      validates_presence :registration_info
    end
  end
end
