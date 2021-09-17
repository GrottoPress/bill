class CreditNoteItems::IndexPage < MainLayout
  needs credit_note_items : Array(CreditNoteItem)
  needs pages : Lucky::Paginator

  def content
    text "CreditNoteItems::IndexPage"
  end
end
