struct FinalizedInvoices::EditPage < MainLayout
  needs operation : UpdateFinalizedInvoice

  def content
    text "FinalizedInvoices::EditPage"
  end
end
