struct Invoices::EditPage < MainLayout
  needs operation : UpdateInvoice

  def content
    text "Invoices::EditPage"
  end
end
