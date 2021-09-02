class InvoiceItemFactory < Avram::Factory
  def initialize
    set_defaults
  end

  private def set_defaults
    description "Item 1"
    quantity 1
    price 100
  end
end
