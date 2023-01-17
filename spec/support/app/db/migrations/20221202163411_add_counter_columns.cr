class AddCounterColumns::V20221202163411 < Avram::Migrator::Migration::V1
  def migrate
    alter :credit_notes do
      add counter : Int64, unique: true, default: 1
    end

    execute <<-SQL
      CREATE SEQUENCE IF NOT EXISTS credit_notes_counter_sequence;
      SQL

    execute <<-SQL
      ALTER TABLE credit_notes
      ALTER COLUMN counter
      SET DEFAULT NEXTVAL('credit_notes_counter_sequence');
      SQL

    alter :invoices do
      add counter : Int64, unique: true, default: 1
    end

    execute <<-SQL
      CREATE SEQUENCE IF NOT EXISTS invoices_counter_sequence;
      SQL

    execute <<-SQL
      ALTER TABLE invoices
      ALTER COLUMN counter
      SET DEFAULT NEXTVAL('invoices_counter_sequence');
      SQL

    alter :receipts do
      add counter : Int64, unique: true, default: 1
    end

    execute <<-SQL
      CREATE SEQUENCE IF NOT EXISTS receipts_counter_sequence;
      SQL

    execute <<-SQL
      ALTER TABLE receipts
      ALTER COLUMN counter
      SET DEFAULT NEXTVAL('receipts_counter_sequence');
      SQL

    alter :transactions do
      add counter : Int64, unique: true, default: 1
    end

    execute <<-SQL
      CREATE SEQUENCE IF NOT EXISTS transactions_counter_sequence;
      SQL

    execute <<-SQL
      ALTER TABLE transactions
      ALTER COLUMN counter
      SET DEFAULT NEXTVAL('transactions_counter_sequence');
      SQL
  end

  def rollback
    alter :credit_notes do
      remove :counter
    end

    execute <<-SQL
      DROP SEQUENCE IF EXISTS credit_notes_counter_sequence;
      SQL

    alter :invoices do
      remove :counter
    end

    execute <<-SQL
      DROP SEQUENCE IF EXISTS invoices_counter_sequence;
      SQL

    alter :receipts do
      remove :counter
    end

    execute <<-SQL
      DROP SEQUENCE IF EXISTS receipts_counter_sequence;
      SQL

    alter :transactions do
      remove :counter
    end

    execute <<-SQL
      DROP SEQUENCE IF EXISTS transactions_counter_sequence;
      SQL
  end
end
