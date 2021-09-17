class CreditNotesStatus::Update < BrowserAction
  include Bill::CreditNotesStatus::Update

  patch "/credit-notes/:credit_note_id/status" do
    run_operation
  end
end
