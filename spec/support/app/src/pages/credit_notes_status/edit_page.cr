class CreditNotesStatus::EditPage < MainLayout
  needs operation : UpdateCreditNoteStatus

  def content
    text "CreditNotesStatus::EditPage"
  end
end
