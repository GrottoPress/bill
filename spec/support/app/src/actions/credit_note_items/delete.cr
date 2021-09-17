class CreditNoteItems::Delete < BrowserAction
  include Bill::CreditNoteItems::Delete

  delete "/credit-notes/line-items/:credit_note_item_id" do
    run_operation
  end
end
