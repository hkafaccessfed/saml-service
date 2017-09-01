Sequel.migration do
  up do
    alter_table :api_subjects do
     add_unique_constraint :x509_cn
    end
  end

  down do
    alter_table :api_subjects do
      drop_unique_constraint :x509_cn
    end
  end
end
