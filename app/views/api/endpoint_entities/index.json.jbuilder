json.identity_providers @idp_ents do |ent|
  json.entity_id ent
  json.names ent
  json.tags ent
end if @idp_ents.size > 0

json.service_providers @sp_ents do |ent|
  json.entity_id ent
  json.descovery_response ent
  json.names ent
  json.tags ent
end if @sp_ents.size > 0

@all
