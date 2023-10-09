class AddTransactionsReference::V20231009211003 < Avram::Migrator::Migration::V1
  def migrate
    alter :transactions do
      add status : String, default: "Open"
    end
  end

  def rollback
    alter :transactions do
      remove :status
    end
  end
end
