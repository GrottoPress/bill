class CreateTransactions::V20210910215906 < Avram::Migrator::Migration::V1
  def migrate
    create :transactions do
      primary_key id : Int64

      add_belongs_to user : User, on_delete: :cascade

      add amount : Int32
      add created_at : Time
      add description : String
      add metadata : JSON::Any?
      add type : String
    end
  end

  def rollback
    drop :transactions
  end
end
