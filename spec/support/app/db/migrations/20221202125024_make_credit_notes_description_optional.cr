class MakeCreditNotesDescriptionOptional::V20221202125024 <
  Avram::Migrator::Migration::V1

  def migrate
    make_optional :credit_notes, :description
  end

  def rollback
    make_required :credit_notes, :description
  end
end
