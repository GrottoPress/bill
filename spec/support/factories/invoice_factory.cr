class InvoiceFactory < Avram::Factory
  def initialize
    set_defaults
  end

  private def set_defaults
    description "New invoice"
    due_at 3.days.from_now.to_utc
    status :draft
  end
end
