# IDPSSODescriptor.all
json.identity_providers @identity_providers do |idp|
  json.entity_id idp.entity_descriptor.known_entity.entity_id

  json.names idp.ui_info.display_names do |name|
    json.value name.value
    json.lang name.lang
  end

  json.tags idp.entity_descriptor.known_entity.tags
end

# SPSSODescriptor.all
json.service_providers @service_providers do |sp|
  json.entity_id sp.entity_descriptor.known_entity.entity_id

  first_disc_response = sp.discovery_response_services.first
  disc_response = sp.discovery_response_services
                  .find(&:is_default) || first_disc_response

  json.discovery_response disc_response

  json.names sp.ui_info.display_names do |name|
    json.value name.value
    json.lang name.lang
  end

  json.tags sp.entity_descriptor.known_entity.tags
end
