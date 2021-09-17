class CreditNoteItems::NewPage < MainLayout
  needs operation : CreateCreditNoteItem

  def content
    text "CreditNoteItems::NewPage"
  end
end
