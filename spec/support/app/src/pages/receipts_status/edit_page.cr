class ReceiptsStatus::EditPage < MainLayout
  needs operation : UpdateReceiptStatus

  def content
    text "ReceiptsStatus::EditPage"
  end
end
