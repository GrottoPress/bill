class CreditNotesStatus::Edit < BrowserAction
  include Bill::CreditNotesStatus::Edit

  get "/credit-notes/:credit_note_id/status/edit" do
    operation = UpdateCreditNoteStatus.new(credit_note)
    html EditPage, operation: operation
  end
end
