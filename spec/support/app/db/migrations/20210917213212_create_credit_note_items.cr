class CreateCreditNoteItems::V20210917213212 < Avram::Migrator::Migration::V1
  def migrate
    create :credit_note_items do
      primary_key id : Int64

      add_timestamps
      add_belongs_to credit_note : CreditNote, on_delete: :cascade

      add description : String
      add quantity : Int16
      add price : Int32
    end
  end

  def rollback
    drop :credit_note_items
  end
end
