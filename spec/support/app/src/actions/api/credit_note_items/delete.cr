class Api::CreditNoteItems::Delete < ApiAction
  include Bill::Api::CreditNoteItems::Delete

  delete "/credit-notes/line-items/:credit_note_item_id" do
    run_operation
  end
end
