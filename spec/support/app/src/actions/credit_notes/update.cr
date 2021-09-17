class CreditNotes::Update < BrowserAction
  include Bill::CreditNotes::Update

  patch "/credit-notes/:credit_note_id" do
    run_operation
  end
end
