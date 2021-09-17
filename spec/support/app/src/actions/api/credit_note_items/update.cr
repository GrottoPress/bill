class Api::CreditNoteItems::Update < ApiAction
  include Bill::Api::CreditNoteItems::Update

  patch "/credit-notes/line-items/:credit_note_item_id" do
    run_operation
  end
end
