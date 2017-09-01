Sequel.migration do
  change do
    # This field already existed but was renamed in the 20160920023804 migration
    alter_table :metadata_instances do
      add_column :primary_tag, String, null: false
    end

    execute 'update metadata_instances set primary_tag = identifier'
  end
end
