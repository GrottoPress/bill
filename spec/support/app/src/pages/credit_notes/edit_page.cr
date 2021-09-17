class CreditNotes::EditPage < MainLayout
  needs operation : UpdateCreditNote

  def content
    text "CreditNotes::EditPage"
  end
end
