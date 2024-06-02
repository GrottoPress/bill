class RemoveTransactionsMetadata::V20240602194034 < Avram::Migrator::Migration::V1
  def migrate
    alter :transactions do
      remove :metadata
    end
  end

  def rollback
    alter :transactions do
      add metadata : JSON::Any?
    end
  end
end
