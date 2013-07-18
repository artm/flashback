Sequel.migration do
  change do
    create_table(:cards) do
      primary_key :id
      String :front
      String :back
      Integer :level, default: 0
      Date :show_at
    end
  end
end
