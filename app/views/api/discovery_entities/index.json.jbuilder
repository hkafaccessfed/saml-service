json.ignore_nil!

def insert_localized_url(json, obj)
  json.url obj.uri
  json.lang obj.lang
end

def insert_ui_info(json, ui_info)
  display_names = ui_info.try(:display_names) || []
  json.names(display_names, :value, :lang)

  logos = ui_info.try(:logos) || []
  json.logos(logos) { |logo| insert_localized_url(json, logo) }

  descriptions = ui_info.try(:descriptions) || []
  json.descriptions(descriptions, :value, :lang)
end

def insert_tags(json, entity, role_descriptor)
  tags = role_descriptor.tags.map(&:name)
  tags += entity.known_entity.tags.map(&:name)
  json.tags(tags.uniq)
end

json.identity_providers(@identity_providers) do |idp|
  idp_sso_descriptor = idp.idp_sso_descriptors.first
  ui_info = idp_sso_descriptor.ui_info
  disco_hints = idp_sso_descriptor.disco_hints

  json.entity_id(idp.entity_id.uri)

  insert_tags(json, idp, idp_sso_descriptor)
  insert_ui_info(json, ui_info)

  geolocations = disco_hints.try(:geolocation_hints) || []
  json.geolocations(geolocations, :latitude, :longitude, :altitude)

  domains = disco_hints.try(:domain_hints) || []
  json.domains(domains.map(&:domain))
end

json.service_providers(@service_providers) do |sp|
  sp_sso_descriptor = sp.sp_sso_descriptors.first
  ui_info = sp_sso_descriptor.ui_info

  json.entity_id(sp.entity_id.uri)

  discovery_response_endpoints =
    sp_sso_descriptor.discovery_response_services
    .sort_by { |e| [e.default? ? 0 : 1, e.id] }
    .map(&:location)
  json.discovery_response(discovery_response_endpoints.first)
  json.all_discovery_response_endpoints(discovery_response_endpoints)

  insert_tags(json, sp, sp_sso_descriptor)
  insert_ui_info(json, ui_info)

  information_urls = ui_info.try(:information_urls) || []
  json.information_urls(information_urls) { |o| insert_localized_url(json, o) }

  privacy_statement_urls = ui_info.try(:privacy_statement_urls) || []
  json.privacy_statement_urls(privacy_statement_urls) do |o|
    insert_localized_url(json, o)
  end
end