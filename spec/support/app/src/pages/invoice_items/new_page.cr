struct InvoiceItems::NewPage < MainLayout
  needs operation : CreateInvoiceItem

  def content
    text "InvoiceItems::NewPage"
  end
end
