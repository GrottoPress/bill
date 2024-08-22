struct DirectSalesReceipts::EditPage < MainLayout
  needs operation : UpdateDirectSalesReceipt

  def content
    text "DirectSalesReceipts::EditPage"
  end
end
