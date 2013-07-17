Sequel.migration do
  change do
    create_table(:cards) do
      String :front
      String :back
    end
  end
end
