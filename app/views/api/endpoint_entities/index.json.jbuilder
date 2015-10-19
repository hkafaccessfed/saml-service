json.entities @entities do |ent|
  json.entity_id ent.entity_id

  names = begin
    ent.entity_descriptor
    .idp_sso_descriptors.first.ui_info.display_names
  rescue
    nil
  end

  if names
    json.names names do |name|
      json.value name.value
      json.lang name.lang
    end
  end

  json.tags ent.tags
end
