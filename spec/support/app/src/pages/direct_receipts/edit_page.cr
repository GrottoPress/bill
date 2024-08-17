struct DirectReceipts::EditPage < MainLayout
  needs operation : UpdateDirectReceipt

  def content
    text "DirectReceipts::EditPage"
  end
end
