class CreateUsers::V20210825190505 < Avram::Migrator::Migration::V1
  def migrate
    create :users do
      primary_key id : Int64

      add email : String, unique: true
    end
  end

  def rollback
    drop :users
  end
end
