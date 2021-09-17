class CreateCreditNotes::V20210917212925 < Avram::Migrator::Migration::V1
  def migrate
    create :credit_notes do
      primary_key id : Int64

      add_timestamps
      add_belongs_to invoice : Invoice, on_delete: :cascade

      add description : String
      add notes : String?
      add status : String
    end
  end

  def rollback
    drop :credit_notes
  end
end
