class InvoiceItemSerializer < BaseSerializer
  def initialize(@invoice_item : InvoiceItem)
  end

  def render
    {type: "InvoiceItemSerializer"}
  end
end
