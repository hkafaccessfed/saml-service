module ETL
  module ServiceProviders
    include SSODescriptors

    def service_providers(ed, ed_data)
      ed_data[:saml][:service_providers].each do |sp_ref|
        sp_data = fr_service_providers[sp_ref[:id]]
        next unless sp_data[:saml][:assertion_consumer_services].count > 0

        create_or_update_sp(ed, SPSSODescriptor.dataset, sp_data)
      end
    end

    def create_or_update_sp(ed, ds, sp_data)
      attrs = sp_attrs(sp_data)
      sp = create_or_update_by_fr_id(ds, sp_data[:id], attrs) do |obj|
        obj.entity_descriptor = ed
        obj.organization = ed.organization
      end

      sp_saml_core(sp, sp_data)
      mdui(sp, sp_data[:display_name], sp_data[:description])
    end

    def sp_attrs(sp_data)
      saml = sp_data[:saml]
      {
        created_at: Time.parse(sp_data[:created_at]),
        enabled: sp_data[:functioning],
        authn_requests_signed: saml[:authnrequests_signed],
        want_assertions_signed: saml[:assertions_signed]
      }
    end

    def sp_saml_core(sp, sp_data)
      saml = sp_data[:saml]
      sso_descriptor(sp, saml[:sso_descriptor])

      assertion_consumer_services(sp, saml[:assertion_consumer_services])
      discovery_response_services(sp, saml[:discovery_response_services])
    end

    def assertion_consumer_services(sp, acservices_data)
      sp.assertion_consumer_services.each(&:destroy)
      acservices_data.each do |acs_data|
        next unless acs_data[:functioning]

        acs = AssertionConsumerService.new(is_default: acs_data[:is_default],
                                           index: acs_data[:index],
                                           location: acs_data[:location],
                                           binding: acs_data[:binding][:uri])
        sp.add_assertion_consumer_service(acs)
      end
    end

    def discovery_response_services(sp, drservices_data)
      sp.discovery_response_services.each(&:destroy)
      drservices_data.each do |drs_data|
        next unless drs_data[:functioning]

        drs = DiscoveryResponseService.new(is_default: drs_data[:is_default],
                                           index: drs_data[:index],
                                           location: drs_data[:location],
                                           binding: drs_data[:binding][:uri])
        sp.add_discovery_response_service(drs)
      end
    end
  end
end
