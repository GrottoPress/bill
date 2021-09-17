class CreditNotes::ShowPage < MainLayout
  needs credit_note : CreditNote

  def content
    text "CreditNotes::ShowPage"
  end
end
