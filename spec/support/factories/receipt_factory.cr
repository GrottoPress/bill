class ReceiptFactory < Avram::Factory
  def initialize
    set_defaults
  end

  private def set_defaults
    amount 200
    business_details "ACME Inc, 123 Joe Boy Street, Antarctica."
    description "New receipt"
    status :draft
    user_details "Kofi, 456 Obogu Street, Damongo."
  end
end
