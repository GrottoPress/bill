class MakeReferenceUnique::V20220731165443 < Avram::Migrator::Migration::V1
  def migrate
    create_index :credit_notes, [:reference], unique: true
    create_index :invoices, [:reference], unique: true
    create_index :receipts, [:reference], unique: true
  end

  def rollback
    drop_index :credit_notes, [:reference]
    drop_index :invoices, [:reference]
    drop_index :receipts, [:reference]
  end
end
