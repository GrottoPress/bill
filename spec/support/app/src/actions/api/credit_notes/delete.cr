class Api::CreditNotes::Delete < ApiAction
  include Bill::Api::CreditNotes::Delete

  delete "/credit-notes/:credit_note_id" do
    run_operation
  end
end
