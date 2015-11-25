module MDUI
  class DiscoHints < Sequel::Model
    many_to_one :idp_sso_descriptor, class: 'IDPSSODescriptor'

    one_to_many :ip_hints
    one_to_many :domain_hints
    one_to_many :geolocation_hints

    plugin :association_dependencies, ip_hints: :destroy,
                                      domain_hints: :destroy,
                                      geolocation_hints: :destroy

    def validate
      super
      validates_presence [:idp_sso_descriptor, :created_at, :updated_at]
    end
  end
end
