class Api::CreditNotes::Update < ApiAction
  include Bill::Api::CreditNotes::Update

  patch "/credit-notes/:credit_note_id" do
    run_operation
  end
end
