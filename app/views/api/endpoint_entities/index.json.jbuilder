def get_entity(ent)
  known_ent_id = ent.entity_descriptor.known_entity_id
  KnownEntity.find(id: known_ent_id)
end

json.identity_providers @idp_ents do |ent|
  target_entity = get_entity ent
  json.entity_id target_entity.entity_id

  json.names ent.ui_info.display_names do |name|
    json.value name.value
    json.lang name.lang
  end

  json.tags target_entity.tags
end if @idp_ents.size > 0

json.service_providers @sp_ents do |ent|
  target_entity = get_entity ent
  json.entity_id target_entity.entity_id

  json.names ent.ui_info.display_names do |name|
    json.value name.value
    json.lang name.lang
  end

  json.tags target_entity.tags
end if @sp_ents.size > 0

