class CreateUsers::V20210825190505 < Avram::Migrator::Migration::V1
  def migrate
    enable_extension "citext"

    create :users do
      primary_key id : Int64

      add email : String, unique: true, case_sensitive: false
    end
  end

  def rollback
    drop :users
  end
end
