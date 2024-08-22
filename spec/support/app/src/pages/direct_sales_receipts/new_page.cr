struct DirectSalesReceipts::NewPage < MainLayout
  needs operation : CreateDirectSalesReceipt

  def content
    text "DirectSalesReceipts::NewPage"
  end
end
