# frozen_string_literal: true

namespace :xsd do
  schemas = {
    'schema/xml.xsd' =>
    'http://www.w3.org/2001/xml.xsd',

    'schema/xenc-schema.xsd' =>
    'http://www.w3.org/TR/2002/REC-xmlenc-core-20021210/xenc-schema.xsd',

    'schema/xmldsig-core-schema.xsd' =>
    'http://www.w3.org/TR/2002/REC-xmldsig-core-20020212/xmldsig-core-schema.xsd#',

    'schema/saml-schema-assertion-2.0.xsd' =>
    'http://docs.oasis-open.org/security/saml/v2.0/saml-schema-assertion-2.0.xsd',

    'schema/saml-schema-metadata-2.0.xsd' =>
    'http://docs.oasis-open.org/security/saml/v2.0/saml-schema-metadata-2.0.xsd',

    'schema/saml-schema-protocol-2.0.xsd' =>
    'http://docs.oasis-open.org/security/saml/v2.0/saml-schema-protocol-2.0.xsd',

    'schema/sstc-saml-metadata-ui-v1.0.xsd' =>
    'http://docs.oasis-open.org/security/saml/Post2.0/sstc-saml-metadata-ui/v1.0/cs01/xsd/sstc-saml-metadata-ui-v1.0.xsd',

    'schema/saml-metadata-rpi-v1.0.xsd' =>
    'http://docs.oasis-open.org/security/saml/Post2.0/saml-metadata-rpi/v1.0/cs01/xsd/saml-metadata-rpi-v1.0.xsd',

    'schema/sstc-metadata-attr.xsd' =>
    'http://docs.oasis-open.org/security/saml/Post2.0/sstc-metadata-attr.xsd',

    'schema/sstc-saml-idp-discovery.xsd' =>
    'http://docs.oasis-open.org/security/saml/Post2.0/sstc-saml-idp-discovery.xsd',

    'schema/oasis-200401-wss-wssecurity-utility-1.0.xsd' =>
    'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd',

    'schema/oasis-200401-wss-wssecurity-secext-1.0.xsd' =>
    'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd',

    'schema/ws-addr.xsd' =>
    'http://www.w3.org/2006/03/addressing/ws-addr.xsd',

    'schema/MetadataExchange.xsd' =>
    'http://schemas.xmlsoap.org/ws/2004/09/mex/MetadataExchange.xsd',

    'schema/ws-securitypolicy-1.2.xsd' =>
    'http://docs.oasis-open.org/ws-sx/ws-securitypolicy/v1.2/errata01/os/schemas/ws-securitypolicy-1.2.xsd',

    'schema/ws-federation.xsd' =>
    'http://docs.oasis-open.org/wsfed/federation/v1.2/os/ws-federation.xsd',

    'schema/ws-privacy.xsd' =>
    'http://docs.oasis-open.org/wsfed/authorization/v1.2/os/ws-authorization.xsd',

    'schema/refeds_metadata_extension_schema.xsd' =>
    'https://s3-ap-southeast-2.amazonaws.com/aaf-binaries/schema/refeds_metadata_extension_schema.xsd'
  }

  task all: schemas.keys

  rule '.xsd' do |t|
    uri = schemas[t.name]
    print "Downloading #{uri} to #{t.name}..."

    response = Net::HTTP.get_response(URI.parse(uri))
    response.value

    File.open(t.name, 'w') do |f|
      f.syswrite(response.body)
    end
    puts 'done.'
    puts "(sha256sum: #{OpenSSL::Digest::SHA256.hexdigest(response.body)})"
    puts
  end
end
