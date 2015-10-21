# IDPSSODescriptor.all
json.identity_providers @identity_providers do |ent|
  json.entity_id ent.entity_descriptor.known_entity.entity_id

  json.names ent.ui_info.display_names do |name|
    json.value name.value
    json.lang name.lang
  end

  json.tags ent.entity_descriptor.known_entity.tags
end

# SPSSODescriptor.all
json.service_providers @service_providers do |ent|
  json.entity_id ent.entity_descriptor.known_entity.entity_id

  json.discovery_response DiscoveryResponseService
    .where(sp_sso_descriptor_id: ent.id, is_default: true).first

  json.names ent.ui_info.display_names do |name|
    json.value name.value
    json.lang name.lang
  end

  json.tags ent.entity_descriptor.known_entity.tags
end
