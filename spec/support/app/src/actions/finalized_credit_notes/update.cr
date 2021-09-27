class FinalizedCreditNotes::Update < BrowserAction
  include Bill::FinalizedCreditNotes::Update

  patch "/credit-notes/:credit_note_id/finalized" do
    run_operation
  end
end
