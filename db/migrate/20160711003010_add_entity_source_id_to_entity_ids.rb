Sequel.migration do
  change do
    alter_table :entity_ids do
      add_foreign_key :entity_source_id, :entity_sources
      add_index [:entity_source_id, :sha1], unique: true
    end

    execute <<-SQL.strip_heredoc
      UPDATE entity_ids ei
      LEFT OUTER JOIN entity_descriptors ed
      ON ed.id = ei.entity_descriptor_id
      LEFT OUTER JOIN known_entities edki
      ON edki.id = ed.known_entity_id
      LEFT OUTER JOIN raw_entity_descriptors red
      ON red.id = ei.raw_entity_descriptor_id
      LEFT OUTER JOIN known_entities redki
      ON redki.id = red.known_entity_id
      SET ei.entity_source_id =
        IFNULL(edki.entity_source_id, redki.entity_source_id)
    SQL
  end
end
