class CreditNoteItems::Create < BrowserAction
  include Bill::CreditNoteItems::Create

  post "/credit-notes/:credit_note_id/line-items" do
    run_operation
  end
end
