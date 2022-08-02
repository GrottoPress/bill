class CreditNoteItems::New < BrowserAction
  include Bill::CreditNoteItems::New

  get "/credit-notes/:credit_note_id/line-items/new" do
    operation = CreateCreditNoteItem.new(credit_note_id: _credit_note_id)
    html NewPage, operation: operation
  end
end
