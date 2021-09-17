class Api::CreditNotesStatus::Update < ApiAction
  include Bill::Api::CreditNotesStatus::Update

  patch "/credit-notes/:credit_note_id/status" do
    run_operation
  end
end
