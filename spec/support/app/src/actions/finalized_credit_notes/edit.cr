class FinalizedCreditNotes::Edit < BrowserAction
  include Bill::FinalizedCreditNotes::Edit

  get "/credit-notes/:credit_note_id/finalized/edit" do
    operation = UpdateFinalizedCreditNote.new(credit_note)

    html EditPage, operation: operation
  end
end
