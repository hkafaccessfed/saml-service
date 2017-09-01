Sequel.migration do
  up do
    alter_table :metadata_instances do
      rename_column :primary_tag, :identifier
      add_index :identifier, unique: true
      drop_index :primary_tag
    end
  end

  down do
    alter_table :metadata_instances do
      rename_column :identifier, :primary_tag
      add_index :primary_tag, unique: true
      drop_index :identifier
    end
  end
end
