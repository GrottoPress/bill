struct InvoiceItems::EditPage < MainLayout
  needs operation : UpdateInvoiceItem

  def content
    text "InvoiceItems::EditPage"
  end
end
