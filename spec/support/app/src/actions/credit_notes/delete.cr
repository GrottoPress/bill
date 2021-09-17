class CreditNotes::Delete < BrowserAction
  include Bill::CreditNotes::Delete

  delete "/credit-notes/:credit_note_id" do
    run_operation
  end
end
