class MakeInvoicesDescriptionOptional::V20221202124733 <
  Avram::Migrator::Migration::V1

  def migrate
    make_optional :invoices, :description
  end

  def rollback
    make_required :invoices, :description
  end
end
