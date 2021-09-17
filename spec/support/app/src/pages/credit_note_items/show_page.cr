class CreditNoteItems::ShowPage < MainLayout
  needs credit_note_item : CreditNoteItem

  def content
    text "CreditNoteItems::ShowPage"
  end
end
