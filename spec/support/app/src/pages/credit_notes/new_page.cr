class CreditNotes::NewPage < MainLayout
  needs operation : CreateCreditNote

  def content
    text "CreditNotes::NewPage"
  end
end
