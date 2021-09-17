class CreditNotes::IndexPage < MainLayout
  needs credit_notes : Array(CreditNote)
  needs pages : Lucky::Paginator

  def content
    text "CreditNotes::IndexPage"
  end
end
