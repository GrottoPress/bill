class CreditNoteItems::EditPage < MainLayout
  needs operation : UpdateCreditNoteItem

  def content
    text "CreditNoteItems::EditPage"
  end
end
