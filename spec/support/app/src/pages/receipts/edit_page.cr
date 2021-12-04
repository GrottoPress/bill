struct Receipts::EditPage < MainLayout
  needs operation : UpdateReceipt

  def content
    text "Receipts::EditPage"
  end
end
