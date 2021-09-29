class AddTotalsColumns::V20210928142258 < Avram::Migrator::Migration::V1
  def migrate
    alter :invoices do
      add totals : JSON::Any?
    end

    alter :credit_notes do
      add totals : JSON::Any?
    end
  end

  def rollback
    alter :invoices do
      remove :totals
    end

    alter :credit_notes do
      remove :totals
    end
  end
end
