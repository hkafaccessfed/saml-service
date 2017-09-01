# frozen_string_literal: true

class Tag < Sequel::Model
  URL_SAFE_BASE_64_ALPHABET = /^[a-zA-Z0-9_-]+$/

  include Parents
  plugin :validation_helpers
  many_to_one :known_entity

  alias derived? derived

  def validate
    super
    validates_unique(%i[name known_entity])
    validates_presence %i[known_entity name created_at updated_at]
    validates_format(URL_SAFE_BASE_64_ALPHABET,
                     :name, message: 'is not in base64 urlsafe alphabet')
  end

  IDP = 'idp'.freeze
  AA = 'aa'.freeze
  STANDALONE_AA = 'standalone-aa'.freeze
  SP = 'sp'.freeze
  RESEARCH_SCHOLARSHIP = 'research-and-scholarship'.freeze
  SIRTFI = 'sirtfi'.freeze
  BLACKLIST = 'blacklist'.freeze
end
