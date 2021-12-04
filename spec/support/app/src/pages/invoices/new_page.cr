struct Invoices::NewPage < MainLayout
  needs operation : CreateInvoice

  def content
    text "Invoices::NewPage"
  end
end
