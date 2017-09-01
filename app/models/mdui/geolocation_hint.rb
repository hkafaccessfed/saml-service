# frozen_string_literal: true

module MDUI
  class GeolocationHint < Sequel::Model
    many_to_one :disco_hints

    def validate
      super
      validates_presence %i[disco_hints uri created_at updated_at]
    end

    def latitude
      uri_parts[0]
    end

    def longitude
      uri_parts[1]
    end

    def altitude
      uri_parts[2]
    end

    def self.parse_uri_into_parts(uri)
      URI.parse(uri).opaque.partition(';').first.split(',', 3)
    end

    def self.valid_uri?(uri)
      parsed_uri = URI.parse(uri)

      parsed_uri.scheme == 'geo' &&
        parsed_uri.opaque.present? &&
        parsed_uri.opaque.include?(',')
    rescue URI::InvalidURIError
      false
    end

    private

    def uri_parts
      @uri_parts ||= MDUI::GeolocationHint.parse_uri_into_parts(uri)
    end
  end
end
