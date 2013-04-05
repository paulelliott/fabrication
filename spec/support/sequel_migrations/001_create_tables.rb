require 'sequel/extensions/migration'

Sequel.migration do
  up do
    create_table :child_sequel_models do
      primary_key :id
      Integer :parent_sequel_model_id
      Integer :number_field
    end

    create_table :parent_sequel_models do
      primary_key :id
      Integer :before_save_value
      String :dynamic_field
      String :nil_field
      Integer :number_field
      String :string_field
      Boolean :false_field
    end

    create_table :sequel_farmers do
      primary_key :id
      String :kind
    end

    create_table :sequel_knights do
      foreign_key :id, :sequel_farmers, null: false, key: [:id], on_delete: :cascade
      primary_key [:id]
    end
  end

  down do
    drop_table :child_sequel_models
    drop_table :parent_sequel_models
  end
end
