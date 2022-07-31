class AddTransactionsReference::V20220731171902 < Avram::Migrator::Migration::V1
  def migrate
    alter :transactions do
      add reference : String?, unique: true
    end
  end

  def rollback
    alter :transactions do
      remove :reference
    end
  end
end
