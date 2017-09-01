Sequel.migration do
  change do
    create_table :sirtfi_contact_people do
      primary_key :id
      foreign_key :contact_id, :contacts, null: false,
                  foreign_key_constraint_name: 'sirtfi_contact_fkey'
      foreign_key :entity_descriptor_id, :entity_descriptors,
                  foreign_key_constraint_name: 'sirtfi_ed_cp_fkey'
      foreign_key :role_descriptor_id, :role_descriptors,
                  foreign_key_constraint_name: 'sirtfi_rd_cp_fkey'

      String :extensions, text: true

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
