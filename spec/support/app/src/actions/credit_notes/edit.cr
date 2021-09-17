class CreditNotes::Edit < BrowserAction
  include Bill::CreditNotes::Edit

  get "/credit-notes/:credit_note_id/edit" do
    operation = UpdateCreditNote.new(
      credit_note,
      line_items: Array(Hash(String, String)).new
    )

    html EditPage, operation: operation
  end
end
