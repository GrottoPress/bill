struct SalesReceipts::NewPage < MainLayout
  needs operation : CreateSalesReceipt

  def content
    text "SalesReceipts::NewPage"
  end
end
