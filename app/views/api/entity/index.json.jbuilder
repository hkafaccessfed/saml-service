json.entities @entities do |entity|
  json.entitiy_id entity.id
  json.name entity.ui_info
  json.tags entity.tags
end
