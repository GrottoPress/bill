class CreateInvoices::V20210825190900 < Avram::Migrator::Migration::V1
  def migrate
    create :invoices do
      primary_key id : Int64

      add_timestamps
      add_belongs_to user : User, on_delete: :cascade

      add description : String
      add due_at : Time
      add notes : String?
      add status : String
    end
  end

  def rollback
    drop :invoices
  end
end
