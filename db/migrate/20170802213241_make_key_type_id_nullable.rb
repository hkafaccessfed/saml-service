Sequel.migration do
  change do
    alter_table :key_descriptors do
      set_column_allow_null :key_type_id
    end
  end
end
