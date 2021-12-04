struct FinalizedReceipts::EditPage < MainLayout
  needs operation : UpdateFinalizedReceipt

  def content
    text "FinalizedReceipts::EditPage"
  end
end
