if defined?(Sequel)
  Sequel.migration do
    up do
      create_table :child_sequel_models do
        primary_key :id
        Integer :parent_sequel_model_id
        Integer :number_field
      end

      create_table :parent_sequel_models do
        primary_key :id
        String :kind
        Integer :before_validation_value
        Integer :before_save_value
        String :dynamic_field
        String :nil_field
        Integer :number_field
        String :string_field
        Boolean :false_field
      end

      create_table :inherited_sequel_models do
        foreign_key :id, :parent_sequel_models, null: false, key: [:id], on_delete: :cascade
        primary_key [:id]
      end
    end

    down do
      drop_table :child_sequel_models
      drop_table :parent_sequel_models
      drop_table :inherited_sequel_models
    end
  end
end
