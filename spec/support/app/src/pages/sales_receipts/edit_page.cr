struct SalesReceipts::EditPage < MainLayout
  needs operation : UpdateSalesReceipt

  def content
    text "SalesReceipts::EditPage"
  end
end
