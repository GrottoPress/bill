class TransactionFactory < Avram::Factory
  def initialize
    set_defaults
  end

  private def set_defaults
    description "New invoice"
    amount 22
    type :invoice
  end
end
