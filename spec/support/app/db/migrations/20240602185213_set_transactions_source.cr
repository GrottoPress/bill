class SetTransactionsSource::V20240602185213 < Avram::Migrator::Migration::V1
  def migrate
    execute <<-SQL
      UPDATE transactions
      SET source = COALESCE(
        metadata->>'credit_note_id',
        metadata->>'invoice_id',
        metadata->>'receipt_id'
      );
      SQL
  end

  def rollback
    TransactionQuery.new.update(source: nil)
  end
end
