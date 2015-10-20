# IDPSSODescriptor.all
json.identity_providers @idp_ents do |ent|
  json.entity_id ent.entity_descriptor.known_entity.entity_id

  json.names ent.ui_info.display_names do |name|
    json.value name.value
    json.lang name.lang
  end

  json.tags ent.entity_descriptor.known_entity.tags
end if @idp_ents.size > 0

# SPSSODescriptor.all
json.service_providers @sp_ents do |ent|
  json.entity_id ent.entity_descriptor.known_entity.entity_id

  # not sure about discovery_response!! still working on it :)
  if ent.discovery_response_services.first
    json.descovery_response ent.discovery_response_services.first
   end

  json.names ent.ui_info.display_names do |name|
    json.value name.value
    json.lang name.lang
  end

  json.tags ent.entity_descriptor.known_entity.tags
end if @sp_ents.size > 0
