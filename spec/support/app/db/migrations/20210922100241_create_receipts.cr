class CreateReceipts::V20210922100241 < Avram::Migrator::Migration::V1
  def migrate
    create :receipts do
      primary_key id : Int64

      add_timestamps
      add_belongs_to user : User, on_delete: :cascade

      add amount : Int32
      add description : String
      add notes : String?
      add status : String
    end
  end

  def rollback
    drop :receipts
  end
end
