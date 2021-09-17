class CreditNoteFactory < Avram::Factory
  def initialize
    set_defaults
  end

  private def set_defaults
    description "New credit note"
    status :draft
  end
end
