struct InvoiceItems::ShowPage < MainLayout
  needs invoice_item : InvoiceItem

  def content
    text "InvoiceItems::ShowPage"
  end
end
