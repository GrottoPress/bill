class ReceiptFactory < Avram::Factory
  def initialize
    set_defaults
  end

  private def set_defaults
    amount 200
    description "New receipt"
    status :draft
  end
end
