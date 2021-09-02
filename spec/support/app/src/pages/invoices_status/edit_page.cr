class InvoicesStatus::EditPage < MainLayout
  needs operation : UpdateInvoiceStatus

  def content
    text "InvoicesStatus::EditPage"
  end
end
