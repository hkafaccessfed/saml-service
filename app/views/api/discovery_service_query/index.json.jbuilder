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

  sp_disc_response = sp.discovery_response_services
                     .find { |q| q[:is_default] } ||
                     sp.discovery_response_services.first

  json.discovery_response sp_disc_response

  json.names sp.ui_info.display_names do |name|
    json.value name.value
    json.lang name.lang
  end

  json.tags sp.entity_descriptor.known_entity.tags
end
