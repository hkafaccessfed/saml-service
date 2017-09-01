Sequel.migration do
  up do
    alter_table :entity_sources do
      set_column_type :rank, :Bignum
    end
  end

  down do
    alter_table :entity_sources do
      set_column_type :rank, :Integer
    end
  end
end
