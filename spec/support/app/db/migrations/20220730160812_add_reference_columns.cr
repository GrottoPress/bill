class AddReferenceColumns::V20220730160812 < Avram::Migrator::Migration::V1
  def migrate
    alter :credit_notes do
      add reference : String?
    end

    alter :invoices do
      add reference : String?
    end

    alter :receipts do
      add reference : String?
    end
  end

  def rollback
    alter :credit_notes do
      remove :reference
    end

    alter :invoices do
      remove :reference
    end

    alter :receipts do
      remove :reference
    end
  end
end
