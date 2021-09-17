class CreditNoteItems::Update < BrowserAction
  include Bill::CreditNoteItems::Update

  patch "/credit-notes/line-items/:credit_note_item_id" do
    run_operation
  end
end
