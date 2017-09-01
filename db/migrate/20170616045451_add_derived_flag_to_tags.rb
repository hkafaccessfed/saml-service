Sequel.migration do
  change do
    alter_table :tags do
      add_column :derived, TrueClass, default: false
    end
  end
end
