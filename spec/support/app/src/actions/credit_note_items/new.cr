class CreditNoteItems::New < BrowserAction
  include Bill::CreditNoteItems::New

  get "/credit-notes/:credit_note_id/line-items/new" do
    operation = CreateCreditNoteItem.new(credit_note_id: credit_note_id.to_i64)
    html NewPage, operation: operation
  end
end
