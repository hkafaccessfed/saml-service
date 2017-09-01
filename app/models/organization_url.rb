# frozen_string_literal: true

class OrganizationURL < LocalizedURI
  many_to_one :organization

  def validate
    super
    validates_presence :organization
  end
end
