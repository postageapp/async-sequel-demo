Sequel.migration do
  up do
    create_table(:raptors) do
      primary_key :id
      String :name, null: false
    end
  end

  down do
    drop_table(:raptors)
  end
end
