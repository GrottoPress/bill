struct Receipts::NewPage < MainLayout
  needs operation : CreateReceipt

  def content
    text "Receipts::NewPage"
  end
end
