class TransactionFactory < Avram::Factory
  def initialize
    set_defaults
  end

  private def set_defaults
    description "New invoice"
    amount 22
    type :invoice
    created_at Time.utc
  end
end
