class Api::FinalizedCreditNotes::Update < ApiAction
  include Bill::Api::FinalizedCreditNotes::Update

  patch "/credit-notes/:credit_note_id/finalized" do
    run_operation
  end
end
