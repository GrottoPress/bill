struct DirectReceipts::NewPage < MainLayout
  needs operation : CreateDirectReceipt

  def content
    text "DirectReceipts::NewPage"
  end
end
