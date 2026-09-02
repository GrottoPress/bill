class CreditNotes::Edit < BrowserAction
  include Bill::CreditNotes::Edit

  get "/credit-notes/:credit_note_id/edit" do
    operation = UpdateCreditNote.new(credit_note)

    html EditPage, operation: operation
  end
end
