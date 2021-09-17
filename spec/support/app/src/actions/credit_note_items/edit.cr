class CreditNoteItems::Edit < BrowserAction
  include Bill::CreditNoteItems::Edit

  get "/credit-notes/line-items/:credit_note_item_id/edit" do
    operation = UpdateCreditNoteItem.new(credit_note_item)
    html EditPage, operation: operation
  end
end
