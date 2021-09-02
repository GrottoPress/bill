class InvoiceSerializer < BaseSerializer
  def initialize(@invoice : Invoice)
  end

  def render
    {type: "InvoiceSerializer"}
  end
end
