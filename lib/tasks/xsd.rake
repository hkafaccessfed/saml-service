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
    'http://docs.oasis-open.org/security/saml/Post2.0/sstc-saml-idp-discovery.xsd'
  }

  task all: schemas.keys

  rule '.xsd' do |t|
    uri = schemas[t.name]
    print "Downloading #{uri} to #{t.name}..."

    response = Net::HTTP.get_response(URI.parse(uri))
    response.value

    FileUtils.mkdir_p('schema')
    File.open(t.name, 'w').write(response.body)
    puts ' done.'
  end
end
