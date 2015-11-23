Sequel.migration do
  up do
    alter_table :key_descriptors do
      drop_foreign_key :key_info_id
    end

    alter_table :key_infos do
      add_foreign_key :key_descriptor_id, :key_descriptors
    end
  end

  down do
    alter_table :key_descriptors do
      add_foreign_key :key_info_id, :key_infos
    end

    alter_table :key_infos do
      drop_foreign_key :key_descriptor_id
    end
  end
end
