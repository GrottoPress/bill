class InvoiceFactory < Avram::Factory
  def initialize
    set_defaults
  end

  private def set_defaults
    business_details "ACME Inc, 123 Joe Boy Street, Antarctica."
    description "New invoice"
    due_at 3.days.from_now.to_utc
    status :draft
    user_details "Kofi, 456 Obogu Street, Damongo."
  end
end
