class CreateInvoiceItems::V20210831110952 < Avram::Migrator::Migration::V1
  def migrate
    create :invoice_items do
      primary_key id : Int64

      add_timestamps
      add_belongs_to invoice : Invoice, on_delete: :cascade

      add description : String
      add quantity : Int16
      add price : Int32
    end
  end

  def rollback
    drop :invoice_items
  end
end
