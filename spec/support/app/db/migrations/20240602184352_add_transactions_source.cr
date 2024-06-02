class AddTransactionsSource::V20240602184352 < Avram::Migrator::Migration::V1
  def migrate
    alter :transactions do
      add source : String?
    end
  end

  def rollback
    alter :transactions do
      remove :source
    end
  end
end
